# GraphQL::SchemaComparator

![Build status](https://github.com/xuorig/graphql-schema_comparator/actions/workflows/ci.yml/badge.svg)

`GraphQL::SchemaComparator` is a GraphQL Schema comparator. What does that mean? `GraphQL::SchemaComparator` takes
two GraphQL schemas and outputs a list of changes between versions. This is useful for many things:

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
the command line.

After a `gem install graphql-schema_comparator`, use the CLI this way:

```
Commands:
  schema_comparator compare OLD_SCHEMA NEW_SCHEMA  # Compares OLD_SCHEMA with NEW_SCHEMA and returns a list of changes
  schema_comparator help [COMMAND]                 # Describe available commands or one specific command
```

Where OLD_SCHEMA and NEW_SCHEMA can be a string containing a schema IDL or a filename where that IDL is located.

### Example

```
$ ./bin/schema_comparator compare "type Query { a: A } type A { a: String } enum B { A_VALUE }" "type Query { a: A } type A { b: String } enum B { A_VALUE ANOTHER_VALUE }"
⏳  Checking for changes...
🎉  Done! Result:

Detected the following changes between schemas:

🛑  Field `a` was removed from object type `A`
⚠️  Enum value `ANOTHER_VALUE` was added to enum `B`
✅  Field `b` was added to object type `A`
```

## Usage

`GraphQL::SchemaComparator`, provides a simple api for Ruby applications to use.

## Docs

http://www.rubydoc.info/github/xuorig/graphql-schema_comparator/master/GraphQL/SchemaComparator

### GraphQL::SchemaComparator.compare

The compare method takes two arguments, `old_schema` and `new_schema`, the two schemas to compare.

You may provide schema IDL as strings, or provide instances of `GraphQL::Schema`.

The result of `compare` returns a `SchemaComparator::Result` object, from which you can
access information on the changes between the two schemas.

 - `result.breaking?` returns true if any breaking changes were found between the two schemas
 - `result.identical?` returns true if the two schemas were identical
 - `result.breaking_changes` returns the list of breaking changes found between schemas.
 - `result.non_breaking_changes` returns the list of non-breaking changes found between schemas.
 - `result.dangerous_changes` returns the list of dangerous changes found between schemas.
- `result.changes` returns the full list of change objects.

### Change Objects

`GraphQL::SchemaComparator` returns a list of change objects. These change objects
all inherit from `Changes::AbstractChange`

Possible changes are all found in [changes.rb](lib/graphql/schema_comparator/changes.rb).

### Change Criticality

Each change object has a `#criticality` method which returns a `Changes::Criticality` object.
This objects defines how dangerous a change is to a schema.

The different levels of criticality (non_breaking, dangerous, breaking) are explained here:
https://github.com/xuorig/graphql-schema_comparator/blob/master/lib/graphql/schema_comparator/changes/criticality.rb#L6-L19

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
