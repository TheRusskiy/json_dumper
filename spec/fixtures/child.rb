class Child
  attr_accessor :first_name, :age
  def initialize(first_name:, age:)
    self.first_name = first_name
    self.age = age
  end
end

class ChildDumper < JsonDumper::Base
  def preview
    {
      first_name: first_name,
      age: age
    }
  end
end