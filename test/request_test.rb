# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'request'
require 'digest/md5'

module Facebook
  class RequestTest < Test::Unit::TestCase
    def setup
			@instance = Facebook::Request.new
		end

		def teardown
			@instance = nil
		end

		def cba_params
			{:c => 'c', :b => 'b', :a => 'a'}
		end

		def test_instantiated
			assert_instance_of(Facebook::Request, @instance)
		end

		def test_cat_with_three_parameter_hash
			expected = 'a=ab=bc=c'
			actual = @instance.cat( cba_params )
			assert_equal(expected, actual)
		end
    
		def test_signature
			secret = '123'
			expected = Digest::MD5.hexdigest("a=ab=bc=c#{secret}")
			actual = @instance.signature(cba_params, secret)
			assert_equal(expected, actual)
		end

		def test_single_prepare
			call_at = 1
			secret = '123'
			expected = cba_params.merge({:method => 'dog', :call_at => call_at, :sig => Digest::MD5.hexdigest("a=ab=bc=ccall_at=#{call_at}method=dog#{secret}")})
			actual = @instance.prepare( cba_params.merge(:method => 'dog'), secret, call_at )
			assert_equal(expected, actual)
		end
  end
end
