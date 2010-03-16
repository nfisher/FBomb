# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'model'

module Facebook
  class ModelTest < Test::Unit::TestCase
    def setup
      @instance = Model.new
    end

    def teardown
      @instance = nil
    end

    def test_instantiated
      assert_instance_of Model, @instance
    end

    def test_dynamic_finder_returns_model
      result = @instance.find_page_by_name('nathan')
      assert_instance_of Model, result
    end

    def test_dynamic_methods_limited_to_find_prefix
      assert_raise NoMethodError do
        @instance.black_and_blue('nathan')
      end
    end

    def test_dynamic_finder_looks_in_correct_table
      assert_equal 'page', @instance.find_page(1).table_name
    end

    def test_dynamic_finder_ignores_by_clause_for_table_name
      assert_equal 'page', @instance.find_page_by_name('Awesome').table_name
    end

    def test_determine_finder_as_initial
      assert_equal :find_initial, @instance.determine_finder(@instance.method_id_to_matches('find_page_by_name'))
    end

    def test_determine_finder_as_all
      assert_equal :find_all, @instance.determine_finder(@instance.method_id_to_matches('find_page_all_by_name'))
    end

    def test_extract_attribute_names_from_match_with_one_attribute_defined
      assert_equal ['name'], @instance.extract_attribute_names_from_match(@instance.method_id_to_matches('find_page_by_name'))
    end

    def test_extract_attribute_names_from_match_with_two_attributes_defined
      assert_equal ['name','uid'], @instance.extract_attribute_names_from_match(@instance.method_id_to_matches('find_page_by_name'))
    end

    def test_conditions_from_arguments_is_correct_with_one_parameter
      assert_equal 'page_id=1', @instance.construct_conditions_from_arguments(['page_id'], [1])
    end

    def test_conditions_from_arguments_is_correct_with_two_parameters
      assert_equal 'page_id=1 AND uid=2', @instance.construct_conditions_from_arguments(['page_id','uid'], [1,2])
    end
  end
end
