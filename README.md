# JsonDumper

Serialize Ruby into JSON. Cleaner. Faster.

This gem is intended to
* help serialize Ruby objects and ActiveRecord objects into json
* help organize your code
* solve N+1 query problem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_dumper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_dumper

## Usage

Let's say you want to serialize Human object, which has many Cars.
First define a class that is going to serialize Human:
```
class HumanJson < JsonDumper::Base
  def preview
    {
      id: id,
      first_name: first_name,
      last_name: last_name,
      born_at: created_at.strftime('%m/%d/%Y')
    }
  end
end
```
you can call it like that:
```
john = Human.create(
  first_name: 'John',
  last_name: 'Doe',
  created_at: 20.years.ago
)

json = HumanJson.preview(john)
json == {
  id: 1,
  first_name: 'John',
  last_name: 'Doe',
  born_at: '09/19/1997'
}
```

Whenever you invoke a method on a JsonDumper::Base instance and it is missing a similar method is invoked on the object you passed to the serializer.
For example in the snippet above a method `id` is going to be called on `john` object.
```
{
  id: id,
  ...
}
```

Let's introduce an association into the mix:
```
class CarJson < JsonDumper::Base
  def preview
    {
      id: id,
      name: name,
    }
  end
end

class HumanJson < JsonDumper::Base
  # ...
  def details
    preview.merge(
      car: CarJson.preview(car)
    )
  end
end

ferrari = Car.create(
  name: 'Ferrari',
)
john.car = ferrari

json = HumanJson.details(john)
json == {
  id: 1,
  first_name: 'John',
  last_name: 'Doe',
  born_at: '09/19/1997',
  car: {
    id: 1,
    name: 'Ferrari'
  }
}
```

This structure provides a very clean way to specify dependencies for ActiveRecord preloader:
```
class HumanJson < JsonDumper::Base
  def preview
    # ...
  end

  def preview_preload
    {}
  end

  def details
    # ...
  end

  def details_preload
    preview_preload.merge(car: [])
  end
end
```
Furthermore you can omit defining `preview_preload` because JsonDumper returns empty hashes (`{}`) whenever a method does not exist and its name ends with `_preload`.

You can utilize it in the following way:
```
preloader = ActiveRecord::Base::Preloader.new
preloader.preload(john, HumanJson.details_preload)
json = HumanJson.details(john)
```
Another cool feature that you can now do is to do both preloading and serialization in a single command via `fetch_METHOD_NAME`.
This creates a special JsonDumper::Delayed object which delays its execution until it's time to render. This allows to do preloading at render time.

Since this is a common operation you can include `JsonDumper::Base` in your controller.
```
class HumansController < ActionController::Base
  include JsonDumper::Helper

  def show
    human = Human.find(params[:id])
    json = dumper_json(
      my_human: HumanJson.fetch_details(human)
    )
    render json: json
  end

  # OR

  def show
    human = Human.find(params[:id])
    render_dumper_json(
      my_human: HumanJson.fetch_details(human)
    )
  end
end

# going to render:
{
  myHuman: {
    id: 1,
    firstName: 'John',
    lastName: 'Doe',
    bornAt: '09/19/1997',
    car: {
      id: 1,
      name: 'Ferrari'
    }
  }
}
```
Take a note that `dumper_json` also camelizes your keys.

### Usage with [Gon](https://github.com/gazay/gon)

This gem also provides a seamless integration with Gon gem.
The above example could be rewritten in the following way:
```
class HumansController < ActionController::Base
  def show
    human = Human.find(params[:id])
    gon.my_human = HumanJson.fetch_details(human)
  end
end
```

Later in your javascript:
```
    console.log(gon.myHuman);
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/therusskiy/json_dumper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Related blogpost

Check it out [here](http://www.dmitry-ishkov.com/2017/08/better-ruby-serialization-into-json.html)

