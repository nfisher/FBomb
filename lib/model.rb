# To change this template, choose Tools | Templates
# and open the template in the editor.

module Facebook
  class Model
    attr_reader :table_name

    # dynamic finder method, shamelessly extracted from rails
    def method_missing(method_id, *arguments)
      if match = method_id_to_matches(method_id.to_s)
        @table_name = match[1]

        attribute_names = []
        attribute_names ||= extract_attribute_names_from_match(match)

        conditions = construct_conditions_from_arguments(attribute_names, arguments)

        case extra_options = arguments[attribute_names.size]
          when nil
            options = {:conditions => conditions}
          when Hash
        end

        return self
      else
        super
      end
    end

    def method_id_to_matches(method_id)
      /^find_(.*?)(?:_(all_by|by)_(.*?))?$/.match(method_id)
    end

    def determine_finder(match)
      match.captures[1] == 'all_by' ? :find_every : :find_initial
    end

    def extract_attribute_names_from_match(match)
      match.captures.last.split('_and_')
    end

    def construct_conditions_from_arguments(attribute_names, arguments)
      conditions = []
      attribute_names.each_with_index {|name,idx|
        conditions << "#{name}=#{arguments[idx]}"
      }
      conditions.join(' AND ')
    end
    
  end
end
