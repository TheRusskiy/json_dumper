require "spec_helper"

RSpec.describe JsonDumper::KeyTransformer do
  it "can transform deep object's keys" do
    obj = {
      some_value: {
        some_nested_value: {
          some_nested_nested_value: 1
        }
      },
      some_array: [
        1,
        {
          nested_value: 1,
          'string_key' => 'bar'
        }
      ]
    }
    result = JsonDumper::KeyTransformer.keys_to_camelcase(obj)
    expect(result).to eq(
      someValue: {
        someNestedValue: {
          someNestedNestedValue: 1
        }
      },
      someArray: [
        1,
        {
          nestedValue: 1,
          'stringKey' => 'bar'
        }
      ]
    )
  end

  it "can transform arrays" do
    obj = [
      some_value_1: {
        some_nested_value: {
          some_nested_nested_value: 1
        }
      },
      some_value_2: {}
    ]
    result = JsonDumper::KeyTransformer.keys_to_camelcase(obj)
    expect(result).to eq(
      [
        someValue1: {
          someNestedValue: {
            someNestedNestedValue: 1
          }
        },
        someValue2: {}
      ]
    )
  end
end
