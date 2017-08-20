if defined?(Gon)
  # Monkey patching
  class Gon
    class << self
      def set_variable(name, value)
        if value.is_a?(::JsonDumper::Delayed)
          value = Class.new.extend(::JsonDumper::Helper).dumper_fetch(value)
        elsif value.respond_to?(:each)
          value = ::JsonDumper::KeyTransformer.keys_to_camelcase(value)
        end
        current_gon.gon[::JsonDumper::KeyTransformer.camelize(name)] = value
      end
    end
  end
end