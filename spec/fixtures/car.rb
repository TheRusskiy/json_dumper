class Car
  attr_accessor :name
  def initialize(name:)
    self.name = name
  end
end

class CarDumper < JsonDumper::Base
  def preview
    {
      name: name
    }
  end
end