if defined?(Gon)
  # Monkey patching
  class Gon
    class << self
      def set_variable(name, value)
        if value.is_a?(JsonDumper::Delayed)
          value = Class.new.extend(JsonDumper::Helper).dumper_fetch(value)
        end
        current_gon.gon[JsonDumper::KeyTransformer.camelize(name)] = value
      end
    end
  end
end