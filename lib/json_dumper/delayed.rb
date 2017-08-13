module JsonDumper
  class Delayed
    attr_accessor :method_name, :entity, :args, :klass

    def initialize(method_name, entity, args, klass)
      self.method_name = method_name
      self.entity = entity
      self.args = args
      self.klass = klass
    end
  end
end