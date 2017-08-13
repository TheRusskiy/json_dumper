class Human
  attr_accessor :name, :legs, :arms
  def initialize(name:, legs:, arms:)
    self.name = name
    self.legs = legs
    self.arms = arms
  end
end

class HumanDumper < JsonDumper::Base
  def preview
    {
      name: name,
      legs: legs,
      arms: arms
    }
  end
end