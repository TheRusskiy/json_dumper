require "spec_helper"
require "active_record"

RSpec.describe JsonDumper::Helper do
  it "can return delayed object" do
    expect(HumanDumper.fetch_preview_with_car).to be_a(JsonDumper::Delayed)
  end

  it "can preload values" do
    dumper = Class.new.extend(JsonDumper::Helper)
    fake_preloader = double('Preloader')
    expect(dumper).to receive(:preloader).and_return(fake_preloader)
    car = Car.new(name: 'Zaporozec')
    human = Human.new(name: 'Dmitry', arms: 2, legs: 1, car: car)
    expect(fake_preloader).to receive(:preload).with(human, car: [] )
    human_delayed = HumanDumper.fetch_preview_with_car_and_params(human)
    expect(dumper.dump_json(human: human_delayed)).to eq(
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
end
