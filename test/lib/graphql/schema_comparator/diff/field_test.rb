require "test_helper"

class GraphQL::SchemaComparator::Diff::FieldTest < Minitest::Test
  def setup
    @type = GraphQL::ObjectType.define do
      name "Foo"
    end
  end

  def test_field_type_change
    old_field = GraphQL::Field.define do
      name "foo"
      type types.String
    end

    new_field = old_field.redefine { type types.Boolean }

    differ = GraphQL::SchemaComparator::Diff::Field.new(@type, @type, old_field, new_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Field `Foo.foo` changed type from `String` to `Boolean`", change.message
  end

  def test_field_type_change_from_scalar_to_list_of_the_same_type
    old_field = GraphQL::Field.define do
      name "bar"
      type types[types.String]
    end

    new_field = old_field.redefine { type types.String }

    differ = GraphQL::SchemaComparator::Diff::Field.new(@type, @type, old_field, new_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Field `Foo.bar` changed type from `[String]` to `String`", change.message
  end

  def test_field_type_change_from_non_null_to_null_of_the_same_type
    old_field = GraphQL::Field.define do
      name "bar"
      type !types.String
    end

    new_field = old_field.redefine { type types.String }

    differ = GraphQL::SchemaComparator::Diff::Field.new(@type, @type, old_field, new_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Field `Foo.bar` changed type from `String!` to `String`", change.message
  end

  def test_field_type_change_from_null_to_non_null_of_the_same_type
    old_field = GraphQL::Field.define do
      name "bar"
      type types.String
    end

    new_field = old_field.redefine { type !types.String }

    differ = GraphQL::SchemaComparator::Diff::Field.new(@type, @type, old_field, new_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Field `Foo.bar` changed type from `String` to `String!`", change.message
  end

  def test_field_type_change_nullability_change_on_lists_of_same_type
    old_field = GraphQL::Field.define do
      name "bar"
      type !types[types.String]
    end

    new_field = old_field.redefine { type types[types.String] }

    differ = GraphQL::SchemaComparator::Diff::Field.new(@type, @type, old_field, new_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Field `Foo.bar` changed type from `[String]!` to `[String]`", change.message
  end

  def test_field_type_change_withing_lists_of_the_same_underlying_types
    old_field = GraphQL::Field.define do
      name "bar"
      type !types[!types.String]
    end

    new_field = old_field.redefine { type !types[types.String] }

    differ = GraphQL::SchemaComparator::Diff::Field.new(@type, @type, old_field, new_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Field `Foo.bar` changed type from `[String!]!` to `[String]!`", change.message
  end

  def test_field_type_change_withing_and_on_list_of_same_type
    old_field = GraphQL::Field.define do
      name "bar"
      type !types[!types.String]
    end

    new_field = old_field.redefine { type types[types.String] }

    differ = GraphQL::SchemaComparator::Diff::Field.new(@type, @type, old_field, new_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Field `Foo.bar` changed type from `[String!]!` to `[String]`", change.message
  end

  def test_field_type_change_withing_and_on_list_of_same_type_of_different_types
    old_field = GraphQL::Field.define do
      name "bar"
      type !types[!types.String]
    end

    new_field = old_field.redefine { type types[types.Boolean] }

    differ = GraphQL::SchemaComparator::Diff::Field.new(@type, @type, old_field, new_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Field `Foo.bar` changed type from `[String!]!` to `[Boolean]`", change.message
  end
end
