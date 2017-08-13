require "spec_helper"

RSpec.describe JsonDumper do
  it "has a version number" do
    expect(JsonDumper::VERSION).not_to be nil
  end

  it "can serialize a simple class" do
    human = Human.new(name: 'Dmitry', arms: 2, legs: 1)
    json = HumanDumper.preview(human)
    expect(json).to eq(name: 'Dmitry', arms: 2, legs: 1)
  end

  it "can serialize a nested class" do
    car = Car.new(name: 'Zaporozec')
    human = Human.new(name: 'Dmitry', arms: 2, legs: 1, car: car)
    json = HumanDumper.preview_with_car(human)
    expect(json).to eq(
      name: 'Dmitry',
      arms: 2,
      legs: 1,
      car: {
        name: 'Zaporozec'
      }
    )
  end

  it "can return nil for nested" do
    human = Human.new(name: 'Dmitry', arms: 2, legs: 1)
    json = HumanDumper.preview_with_car(human)
    expect(json).to eq(
      name: 'Dmitry',
      arms: 2,
      legs: 1,
      car: nil
    )
  end
end
