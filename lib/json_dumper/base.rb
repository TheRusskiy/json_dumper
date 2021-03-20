module JsonDumper
  class Base
    attr_accessor :entity, :return_nils

    def initialize(entity = nil)
      self.return_nils = entity.nil?
      self.entity = entity
    end

    def self.method_missing(name, *args1, **args2, &block)
      name_sym = name
      name = name.to_s
      value = args1[0]
      if name.start_with?('fetch_')
        return Delayed.new(name.gsub('fetch_', ''), value, args1[1..-1], args2, self)
      end
      if instance.respond_to?(name)
        if value.respond_to?(:each) && !value.respond_to?(:each_pair)
          value.map do |ent|
            new_dumper = new(ent)
            if new_dumper.return_nils
              return nil
            end
            result = if args2.empty?
                       new_dumper.send(name, *(args1[1..-1]), &block)
                     else
                       new_dumper.send(name, *(args1[1..-1]), **args2, &block)
                     end
            if result.respond_to?(:each) && !result.respond_to?(:each_pair)
              result = DumperArray.new(result)
            else
              result = DumperHash.new(result)
            end
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
          result = if args2.empty?
                     new_dumper.send(name, *(args1[1..-1]), &block)
                   else
                     new_dumper.send(name, *(args1[1..-1]), **args2, &block)
                   end
          if result.respond_to?(:each) && !result.respond_to?(:each_pair)
            result = DumperArray.new(result)
          else
            result = DumperHash.new(result)
          end

          preload_method_name = "#{name}_preload"
          result.preload = instance.respond_to?(preload_method_name) ? instance.send(preload_method_name) : {}
          result
        end
      elsif name.end_with?('_preload') && instance.respond_to?(name.gsub('_preload', ''))
        return {}
      else
        if args2.empty?
          super name_sym, *args1, &block
        else
          super name_sym, *args1, *args2, &block
        end
      end
    end

    def self.respond_to_missing?(method_name, _ = false)
      new.respond_to? method_name
    end

    def method_missing(name, *args1, **args2, &block)
      if entity.respond_to? name
        if args2.empty?
          entity.send(name, *args1, &block)
        else
          entity.send(name, *args1, **args2, &block)
        end
      else
        super
      end
    end

    def respond_to_missing?(method_name, _ = false)
      entity.respond_to? method_name
    end

    def self.instance
      @instance ||= new
    end
  end
end
