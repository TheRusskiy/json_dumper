require "spec_helper"
require "active_record"

RSpec.describe JsonDumper::Helper do
  let(:dumper) { Class.new.extend(JsonDumper::Helper) }

  it "can return delayed object" do
    expect(HumanDumper.fetch_preview_with_car).to be_a(JsonDumper::Delayed)
  end

  it "can preload values" do
    fake_preloader = double('Preloader')
    expect(dumper).to receive(:preloader).and_return(fake_preloader)
    car = Car.new(name: 'Zaporozec')
    human = Human.new(name: 'Dmitry', arms: 2, legs: 1, car: car)
    expect(fake_preloader).to receive(:preload).with(human, car: [] )
    human_delayed = HumanDumper.fetch_preview_with_car_and_params(human)
    expect(dumper.dumper_json(human: human_delayed)).to eq(
      human: {
        name: 'Dmitry',
        legs: 1,
        arms: 2,
        car: {
          name: 'Zaporozec'
        },
        someParam: 'some_value'
      }
    )
  end


  it "preloads correctly if returns an array" do
    child1 = Child.new(first_name: 'Nikita', age: 10)
    child2 = Child.new(first_name: 'Natasha', age: 12)
    human = Human.new(name: 'Dmitry', arms: 2, legs: 1, children: [child1, child2])
    children_delayed = HumanDumper.fetch_children(human)
    expect(dumper.dumper_json(children: children_delayed)).to eq(
      children: [
        {
          firstName: 'Nikita',
          age: 10,
        },
        {
          firstName: 'Natasha',
          age: 12
        }
      ]
    )
  end

end
