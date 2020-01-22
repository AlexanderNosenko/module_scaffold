# ModuleScaffold

This gem is designed to be used in projects with:
 * `Pundit` or similar for access management
 * `FastJson` or similar for serialization
 * `Rspec` for testing,
 * `Rswag` for api documentation

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/module_scaffold`. To experiment with that code, run `bin/console` for an interactive prompt.



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'module_scaffold'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install module_scaffold

## Usage

##### Basic usage

```ruby
rails g module_scaffold <Model>
```
* Model - fully specified model class name. Model should implement method #attributes which returns hash with field names as keys.

###### Example

```ruby
rails g module_scaffold Animals::Dog
```

```ruby
create  app/controllers/dogs_controller.rb
create  app/policies/animals/dog_policy.rb
create  app/serializers/animals/dog_serializer.rb
create  app/services/animals/dogs/create_dog.rb
create  app/services/animals/dogs/update_dog.rb
create  app/services/animals/dogs/destroy_dog.rb
create  spec/rswag/animals/dogs_spec.rb
create  spec/descriptors/animals/dog_descriptor.rb
create  spec/policies/animals/dog_policy_spec.rb
create  spec/services/animals/dogs/create_dog_spec.rb
create  spec/services/animals/dogs/update_dog_spec.rb
create  spec/services/animals/dogs/destroy_dog_spec.rb
create  spec/serializers/animals/dog_serializer_spec.rb
  route    resources :dogs, only: [:index, :show, :create, :update, :destroy]
 ```

* You should also load descriptors in `spec_helper`
```ruby
Dir[File.expand_path('descriptors/**/*.rb', __dir__)].each { |f| require f }
```

##### 'I really don't need this file' usage

To get the list of available options please run:

```ruby
rails g module_scaffold -h
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/module_scaffold.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
