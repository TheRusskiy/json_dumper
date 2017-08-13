class Human
  attr_accessor :name, :legs, :arms, :car
  def initialize(name:, legs:, arms:, car: nil)
    self.name = name
    self.legs = legs
    self.arms = arms
    self.car = car
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

  def preview_with_params(extra_param1:, extra_param2:)
    preview.merge(
      param1: extra_param1,
      param2: extra_param2
    )
  end

  def preview_with_car
    preview.merge(
       car: CarDumper.preview(car)
    )
  end

  def preview_with_car_preload
    { car: [] }
  end

  def preview_with_car_and_params
    preview_with_car.merge(some_param: 'some_value')
  end

  def preview_with_car_and_params_preload
    preview_with_car_preload
  end
end