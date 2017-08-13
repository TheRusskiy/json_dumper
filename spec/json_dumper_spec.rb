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
end
