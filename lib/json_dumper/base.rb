module JsonDumper
  class Base
    attr_accessor :entity, :return_nils

    def initialize(entity = nil)
      self.return_nils = entity.nil?
      self.entity = entity
    end

    def self.method_missing(name, *args, &block)
      name_sym = name
      name = name.to_s
      value = args[0]
      if name.start_with?('fetch_')
        return DumperDelayed.new(name.gsub('fetch_', ''), value, args[1..-1], self)
      end
      if instance.respond_to?(name)
        if value.respond_to?(:each) && !value.respond_to?(:each_pair)
          value.map do |ent|
            new_dumper = new(ent)
            if new_dumper.return_nils
              return nil
            end
            result = DumperHash.new(new_dumper.send(name, *(args[1..-1]), &block))
            preload_method_name = "#{name}_preload"
            result.preload = instance.respond_to?(preload_method_name) ? instance.send(preload_method_name) : {}
            result
          end
        elsif name.end_with?('_preload')
          instance.send(name)
        else
          new_dumper = new(value)
          if new_dumper.return_nils
            return nil
          end
          result = DumperHash.new(new_dumper.send(name, *(args[1..-1]), &block))
          preload_method_name = "#{name}_preload"
          result.preload = instance.respond_to?(preload_method_name) ? instance.send(preload_method_name) : {}
          result
        end
      elsif name.end_with?('_preload')
        return {}
      else
        super name_sym, *args, &block
      end
    end

    def self.respond_to_missing?(method_name, _ = false)
      new.respond_to? method_name
    end

    def method_missing(name, *args, &block)
      if entity.respond_to? name
        entity.send(name, *args, &block)
      else
        super name, *args, &block
      end
    end

    def respond_to_missing?(method_name, _ = false)
      entity.respond_to? method_name
    end

    def self.instance
      @instance ||= new
    end

    class DumperHash < Hash
      attr_accessor :preload
      def initialize(hash)
        hash.each_pair do |k, v|
          self[k] = v
        end
      end

      def camel
        keys_to_camelcase
      end
    end

    class DumperDelayed
      attr_accessor :method_name, :entity, :args, :klass

      def initialize(method_name, entity, args, klass)
        self.method_name = method_name
        self.entity = entity
        self.args = args
        self.klass = klass
      end
    end
  end
end