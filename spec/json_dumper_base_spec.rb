require "spec_helper"

RSpec.describe JsonDumper::Base do

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

  it "works correctly if returns an array" do
    child1 = Child.new(first_name: 'Nikita', age: 10)
    child2 = Child.new(first_name: 'Natasha', age: 12)
    human = Human.new(name: 'Dmitry', arms: 2, legs: 1, children: [child1, child2])
    json = HumanDumper.children(human)
    expect(json).to eq([
      {
        first_name: 'Nikita',
        age: 10,
      },
      {
        first_name: 'Natasha',
        age: 12
      }
    ])
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

  it "can serialize an array" do
    human1 = Human.new(name: 'Dmitry', arms: 2, legs: 1)
    human2 = Human.new(name: 'Sergey', arms: 2, legs: 2)
    json = HumanDumper.preview([human1, human2])
    expect(json).to eq(
      [
        {
          name: 'Dmitry',
          arms: 2,
          legs: 1
        },
        {
          name: 'Sergey',
          arms: 2,
          legs: 2
        }
      ]
    )
  end

  it "can pass extra params" do
    human = Human.new(name: 'Dmitry', arms: 2, legs: 1)
    json = HumanDumper.preview_with_params(
      human,
      extra_param1: 'some value',
      extra_param2: 'some other value'
    )
    expect(json).to eq(
      name: 'Dmitry',
      arms: 2,
      legs: 1,
      param1: 'some value',
      param2: 'some other value'
    )
  end

  describe "preloading" do
    it "can get hashes" do
      preload = HumanDumper.preview_preload
      expect(preload).to eq({})
    end

    it "can get empty hashes for methods without preload defined" do
      preload = HumanDumper.preview_with_car_preload
      expect(preload).to eq(car: [])
    end

    it "raises errors on non existing methods" do
      expect { HumanDumper.blabla_preload }.to raise_error NoMethodError
    end
  end
end
