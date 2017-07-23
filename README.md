# GraphQL::SchemaComparator

`GraphQL::SchemaComparator` is a GraphQL Schema comparator. What does that mean? `GraphQL::SchemaComparator` takes
two GraphQL schemas and outputs a list of changes that happened between the two versions. This is useful for many things:

  - Breaking Change detection
  - Applying custom rules to schema changes
  - Building automated tools like linters

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-schema_comparator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graphql-schema_comparator

## CLI

`GraphQL::SchemaComparator` comes with a handy CLI to help compare two schemas using
the commandline.

After a `gem install graphql-schema_comparator`, use the CLI this way:

```bash
graphql-schema-utils compare "schema { query: Query } type Query { a: String }" "schema { query: Query } type Query { b: Int }"
```

And you should get the following result:

![comparator result](http://i.imgur.com/clGVn4E.png)

## Usage

`GraphQL::SchemaComparator`, provides a simple api for Ruby applications to use.

### GraphQL::SchemaComparator.compare

The compare method takes two arguments, `old_schema` and `new_schema`, the two schemas to compare.

You may provide schema IDL as strings, or provide instances of `GraphQL::Schema`.

The result of `compare` returns a `SchemaComparator::Result` object, from which you can
access information on the changes between the two schemas.

 - `result.breaking?` returns true if any breaking changes were found between the two schemas
 - `result.identical?` returns true if the two schemas were identical
 - `result.breaking_changes` returns the list of breaking changes found between schemas.
- `result.changes` returns the full list of change objects.

### Change Objects

Change objects are considered any objects that respond to `message` and `breaking` and they
are all namespaced under the `Changes` module.

Possible changes are all found in [changes.rb](lib/graphql/schema_comparator/changes.rb).

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xuorig/graphql-schema_comparator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
