require "test_helper"

class GraphQL::SchemaComparator::Diff::SchemaTest < Minitest::Test
  def setup
    @old_schema = <<~SCHEMA
      schema {
        query: Query
      }
      input AInput {
        # a
        a: String = "1"
        b: String!
        options: [Options]
      }
      # The Query Root of this schema
      type Query {
        # Just a simple string
        a(anArg: String): String!
        b: BType
        c(arg: Options): Options
      }
      type BType {
        a: String
      }
      type CType {
        a: String @deprecated(reason: "whynot")
        c: Int!
        d(arg: Int): String
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
          option: Options
        ): String
        b(arg: Int = 1): String
      }
      enum Options {
        A
        B
        C
        E
        F @deprecated(reason: "Old")
      }

      # Old
      directive @yolo(
        # Included when true.
        someArg: Boolean!

        anotherArg: String!

        willBeRemoved: Boolean!
      ) on FIELD | FRAGMENT_SPREAD | INLINE_FRAGMENT

      type WillBeRemoved {
        a: String
      }

      directive @willBeRemoved on FIELD
    SCHEMA

    @new_schema =<<~SCHEMA
      schema {
        query: Query
      }
      input AInput {
        # changed
        a: Int = 1
        c: String!
        options: [Options]
      }
      # Query Root description changed
      type Query {
        # This description has been changed
        a: String!
        b: Int!
        c(arg: Options): Options
      }
      input BType {
        a: String!
      }
      type CType implements AnInterface {
        a(arg: Int): String @deprecated(reason: "cuz")
        b: Int!
        d(arg: Int = 10): String
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
      interface ANewInterface {
        c: Int
      }
      type AnotherWithInterfaces implements AnInterface, ANewInterface {
        interfaceField: Int!
        c: Int
      }
      type WithArguments {
        a(
          # Description for a
          a: Int
          b: String!
          option: Options
        ): String
        b(arg: Int = 2): String
      }
      enum Options {
        # Stuff
        A
        B
        D
        E @deprecated
        F @deprecated(reason: "New")
      }

      # New
      directive @yolo(
        # someArg does stuff
        someArg: String!

        anotherArg: String! = "Test"
      ) on FIELD | FIELD_DEFINITION

      directive @yolo2(
        # Included when true.
        someArg: String!
      ) on FIELD
    SCHEMA

    @differ = GraphQL::SchemaComparator::Diff::Schema.new(
      GraphQL::Schema.from_definition(@old_schema),
      GraphQL::Schema.from_definition(@new_schema),
    )
  end

  def test_changes_kitchensink
    assert_equal [
      "Type `WillBeRemoved` was removed",
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
      "Input field `AInput.a` changed type from `String` to `Int`",
      "`CType` object implements `AnInterface` interface",
      "Field `c` was removed from object type `CType`",
      "Field `interfaceField` was added to object type `CType`",
      "Field `b` was added to object type `CType`",
      "Deprecation reason on field `CType.a` has changed from `whynot` to `cuz`",
      "Argument `arg: Int` added to field `CType.a`",
      "Default value `10` was added to argument `arg` on field `CType.d`",
      "Default value for argument `anotherArg` on directive `yolo` changed from `__no_default__` to `Test`",
      "Union member `BType` was removed from Union type `MyUnion`",
      "Union member `DType` was added to Union type `MyUnion`",
      "Field `anotherInterfaceField` was removed from object type `AnotherInterface`",
      "Field `b` was added to object type `AnotherInterface`",
      "`WithInterfaces` object type no longer implements `AnotherInterface` interface",
      "Field `anotherInterfaceField` was removed from object type `WithInterfaces`",
      "Type `ANewInterface` was added",
      "Type `AnotherWithInterfaces` was added",
      "`AnotherWithInterfaces` object implements `AnInterface` interface",
      "Description for argument `a` on field `WithArguments.a` changed from `Meh` to `Description for a`",
      "Type for argument `b` on field `WithArguments.a` changed from `String` to `String!`",
      "Default value for argument `arg` on field `WithArguments.b` changed from `1` to `2`",
      "Enum value `C` was removed from enum `Options`",
      "Enum value `D` was added to enum `Options`",
      "Description for enum value `Options.A` changed from `` to `Stuff`",
      "Enum value `Options.E` was deprecated with reason `No longer supported`",
      "Enum value `Options.F` deprecation reason changed from `Old` to `New`",
      "Directive `willBeRemoved` was removed",
      "Directive `yolo2` was added",
      "Directive `yolo` description changed from `Old` to `New`",
      "Location `FRAGMENT_SPREAD` was removed from directive `yolo`",
      "Location `INLINE_FRAGMENT` was removed from directive `yolo`",
      "Location `FIELD_DEFINITION` was added to directive `yolo`",
      "Argument `willBeRemoved` was removed from directive `yolo`",
      "Description for argument `someArg` on directive `yolo` changed from `Included when true.` to `someArg does stuff`",
      "Type for argument `someArg` on directive `yolo` changed from `Boolean!` to `String!`",
    ].sort.join("\n"), @differ.diff.map(&:message).sort.join("\n")

    assert_equal [
      "WillBeRemoved",
      "DType",
      "Query.a",
      "Query.a.anArg",
      "Query.b",
      "Query",
      "BType",
      "AInput.b",
      "AInput.c",
      "AInput.a",
      "AInput.a",
      "AInput.a",
      "CType",
      "CType.c",
      "CType.b",
      "CType.a",
      "CType.a.arg",
      "CType.d.arg",
      "CType.interfaceField",
      "MyUnion",
      "MyUnion",
      "AnotherInterface.anotherInterfaceField",
      "AnotherInterface.b",
      "WithInterfaces",
      "WithInterfaces.anotherInterfaceField",
      "ANewInterface",
      "AnotherWithInterfaces",
      "AnotherWithInterfaces",
      "WithArguments.a.a",
      "WithArguments.a.b",
      "WithArguments.b.arg",
      "Options.C",
      "Options.D",
      "Options.A",
      "Options.E",
      "Options.F",
      "@willBeRemoved",
      "@yolo2",
      "@yolo",
      "@yolo",
      "@yolo",
      "@yolo",
      "@yolo.willBeRemoved",
      "@yolo.someArg",
      "@yolo.someArg",
      "@yolo.anotherArg",
    ].sort.join("\n"), @differ.diff.map(&:path).sort.join("\n")
  end

  def test_enum_value_changes
    old_schema = <<~SCHEMA
      schema {
        query: Query
      }
      
      type Query {
        a(arg: AInput): OutputEnum
        b(arg: InputEnum): String
      }

      input AInput {
        options: [Input2Enum]
      }
     
      enum InputEnum {
        INPUT_A
        INPUT_B
      }

      enum Input2Enum {
        INPUT2_A
        INPUT2_B
      }

      enum OutputEnum {
        OUTPUT_A
        OUTPUT_B
      }
    SCHEMA

    new_schema = <<~SCHEMA
      schema {
        query: Query
      }
      
      type Query {
        a(arg: AInput): OutputEnum
        b(arg: InputEnum): String
      }

      input AInput {
        options: [Input2Enum]
      }
     
      enum InputEnum {
        INPUT_B
        INPUT_C
      }

      enum Input2Enum {
        INPUT2_B
        INPUT2_C
      }

      enum OutputEnum {
        OUTPUT_B
        OUTPUT_C
      }
    SCHEMA

    expected_changes = [
      {
        path: "InputEnum.INPUT_A",
        message: "Enum value `INPUT_A` was removed from enum `InputEnum`",
        level: GraphQL::SchemaComparator::Changes::Criticality::BREAKING
      },
      {
        path: "InputEnum.INPUT_C",
        message: "Enum value `INPUT_C` was added to enum `InputEnum`",
        level: GraphQL::SchemaComparator::Changes::Criticality::NON_BREAKING
      },
      {
        path: "Input2Enum.INPUT2_A",
        message: "Enum value `INPUT2_A` was removed from enum `Input2Enum`",
        level: GraphQL::SchemaComparator::Changes::Criticality::BREAKING
      },
      {
        path: "Input2Enum.INPUT2_C",
        message: "Enum value `INPUT2_C` was added to enum `Input2Enum`",
        level: GraphQL::SchemaComparator::Changes::Criticality::NON_BREAKING
      },
      {
        path: "OutputEnum.OUTPUT_A",
        message: "Enum value `OUTPUT_A` was removed from enum `OutputEnum`",
        level: GraphQL::SchemaComparator::Changes::Criticality::NON_BREAKING
      },
      {
        path: "OutputEnum.OUTPUT_C",
        message: "Enum value `OUTPUT_C` was added to enum `OutputEnum`",
        level: GraphQL::SchemaComparator::Changes::Criticality::DANGEROUS
      }
    ]

    actual_changes = schema_diff(old_schema, new_schema)
    assert_equal(normalize_schema_diff(expected_changes), normalize_schema_diff(actual_changes))
  end

  def schema_diff(old_schema, new_schema)
    differ = GraphQL::SchemaComparator::Diff::Schema.new(
      GraphQL::Schema.from_definition(old_schema),
      GraphQL::Schema.from_definition(new_schema)
    )
    differ.diff.map do |change|
      {
        path: change.path,
        message: change.message,
        level: change.criticality.level
      }
    end
  end

  def normalize_schema_diff(changes)
    changes.sort_by { |changes| [changes[:path], changes[:message], changes[:level]] }
  end
end
