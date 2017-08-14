module JsonDumper
  class KeyTransformer
    def self.keys_to_camelcase(obj)
      return nil if obj.nil?
      if array_like?(obj)
        return keys_to_camelcase_array(obj)
      end
      result = obj.map do |k, v|
        new_value = if v.respond_to?(:each_pair)
                      keys_to_camelcase(v)
                    elsif array_like?(v)
                      keys_to_camelcase_array(v)
                    else
                      v
                    end
        new_key = if k.is_a?(String)
                    camelize(k)
                  elsif k.is_a?(Symbol)
                    camelize(k.to_s).to_sym
                  else
                    k
                  end
        [new_key, new_value]
      end.to_h
      if defined?(HashWithIndifferentAccess) && obj.is_a?(HashWithIndifferentAccess)
        result = HashWithIndifferentAccess.new(result)
      end
      result
    end

    def self.keys_to_camelcase_array(arr)
      arr.map do |v|
        v.respond_to?(:each_pair) ? keys_to_camelcase(v) : v
      end
    end

    def self.array_like?(obj)
      obj.is_a?(Array) || (defined?(ActiveRecord::Relation) && obj.is_a?(ActiveRecord::Relation))
    end

    def self.camelize(string)
      string.split('_').each_with_index.map do |word, index|
        index == 0 ? word : word.capitalize
      end.join
    end
  end
end