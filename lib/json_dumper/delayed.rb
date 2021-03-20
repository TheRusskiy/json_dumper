module JsonDumper
  class Delayed
    attr_accessor :method_name, :entity, :positional_args, :named_args, :klass

    def initialize(method_name, entity, positional_args, named_args, klass)
      self.method_name = method_name
      self.entity = entity
      self.positional_args = positional_args
      self.named_args = named_args
      self.klass = klass
    end
  end
end
