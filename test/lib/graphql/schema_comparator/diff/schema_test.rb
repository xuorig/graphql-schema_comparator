require "test_helper"

describe GraphQL::SchemaComparator::Diff::Schema do
  let(:old_schema) do
    GraphQL::Schema.from_definition(
      <<~SCHEMA
        schema {
          query: Query
        }
        input AInput {
          # a
          a: String = "1"
          b: String!
        }
        # The Query Root of this schema
        type Query {
          # Just a simple string
          a(anArg: String): String!
          b: BType
        }
        type BType {
          a: String
        }
        type CType {
          a: String @deprecated(reason: "whynot")
          c: Int!
        }
        union MyUnion = CType | BType
        interface AnInterface {
          interfaceField: Int!
        }
        interface AnotherInterface {
          anotherInterfaceField: String
        }
        type WithInterfaces implements AnInterface, AnotherInterface {
          a: String!
        }
        type WithArguments {
          a(
            # Meh
            a: Int
            b: String
          ): String
          b(arg: Int = 1): String
        }
        enum Options {
          A
          B
          C
        }

        directive @yolo(
          # Included when true.
          someArg: Boolean!
        ) on FIELD | FRAGMENT_SPREAD | INLINE_FRAGMENT
      SCHEMA
    )
  end

  let(:new_schema) do
    GraphQL::Schema.from_definition(
      <<~SCHEMA
        schema {
          query: Query
        }
        input AInput {
          # changed
          a: Int = 1
          c: String!
        }
        # Query Root description changed
        type Query {
          # This description has been changed
          a: String!
          b: Int!
        }
        input BType {
          a: String!
        }
        type CType implements AnInterface {
          a(arg: Int): String @deprecated(reason: "cuz")
          b: Int!
        }
        type DType {
          b: Int!
        }
        union MyUnion = CType | DType
        interface AnInterface {
          interfaceField: Int!
        }
        interface AnotherInterface {
          b: Int
        }
        type WithInterfaces implements AnInterface {
          a: String!
        }
        type WithArguments {
          a(
            # Description for a
            a: Int
            b: String!
          ): String
          b(arg: Int = 2): String
        }
        enum Options {
          A
          B
          D
        }

        directive @yolo(
          # Included when true.
          someArg: String!
        ) on FIELD | FIELD_DEFINITION

        directive @yolo2(
          # Included when true.
          someArg: String!
        ) on FIELD
      SCHEMA
    )
  end

  let(:differ) { GraphQL::SchemaComparator::Diff::Schema.new(old_schema, new_schema) }

  describe "#changes" do
    it "kitchensink: returns a list of changes between schemas" do
      assert_equal [
        "Type `DType` was added",
        "Field `Query.a` description changed from `Just a simple string` to `This description has been changed`",
        "Argument `anArg: String` was removed from field `Query.a`",
        "Field `Query.b` changed type from `BType` to `Int!`",
        "Description `The Query Root of this schema` on type `Query` has changed to `Query Root description changed`",
        "`BType` kind changed from `OBJECT` to `INPUT_OBJECT`",
        "Input field `b` was removed from input object type `AInput`",
        "Input field `c` was added to input object type `AInput`",
        "Input field `AInput.a` description changed from `a` to `changed`",
        "Input field `AInput.a` default changed from `1` to `1`",
        "Input field `AInput.a` changed type from String to Int",
        "`CType` object implements `AnInterface` interface",
        "Field `c` was removed from object type `CType`",
        "Field `b` was added to object type `CType`",
        "Deprecation reason on field `CType.a` has changed from `whynot` to `cuz`",
        "Argument `arg: Int` added to field `CType.a`",
        "Union member `BType` was removed from Union type `MyUnion`",
        "Union member `DType` was added to Union type `MyUnion`",
        "Field `anotherInterfaceField` was removed from object type `AnotherInterface`",
        "Field `b` was added to object type `AnotherInterface`",
        "`WithInterfaces` object type no longer implements `AnotherInterface` interface",
        "Description for argument `a` on field `WithArguments.a` changed from `Meh` to `Description for a`",
        "Type for argument `b` on field `WithArguments.a` changed from `String` to `String!`",
        "Default value for argument `arg` on field `WithArguments.b` changed from `1` to `2`",
        "Enum value `C` was removed from enum `Options`",
        "Enum value `D` was added to enum `Options`",
        "Directive `yolo2` was added", "Location `FRAGMENT_SPREAD` was removed from directive `yolo`",
        "Location `INLINE_FRAGMENT` was removed from directive `yolo`",
        "Location `FIELD_DEFINITION` was added to directive `yolo`",
        "Type for argument `someArg` on directive `yolo` changed from `String!` to `Boolean!`"
      ], differ.diff.map(&:message)
    end
  end
end
