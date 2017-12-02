require "test_helper"

class GraphQL::SchemaComparator::ResultTest < Minitest::Test
  def test_changes
    removed_z = GraphQL::SchemaComparator::Changes::FieldRemoved.new(GraphQL::ObjectType.define(name: "Z"), GraphQL::Field.define(name: "a"))
    removed_a = GraphQL::SchemaComparator::Changes::FieldRemoved.new(GraphQL::ObjectType.define(name: "A"), GraphQL::Field.define(name: "a"))
    added_a = GraphQL::SchemaComparator::Changes::FieldAdded.new(GraphQL::ObjectType.define(name: "A"), GraphQL::Field.define(name: "a"))
    result = GraphQL::SchemaComparator::Result.new([removed_z, added_a, removed_a])
    assert_equal [removed_z, removed_a, added_a], result.changes
  end

  def test_identical_returns_false_when_schemas_have_changes
    result = GraphQL::SchemaComparator::Result.new([
      GraphQL::SchemaComparator::Changes::FieldRemoved.new(GraphQL::ObjectType.new, GraphQL::Field.new)
    ])
    assert_equal false, result.identical?
  end

  def test_identical_returns_true_when_schemas_are_the_same
    result = GraphQL::SchemaComparator::Result.new([])
    assert_equal true, result.identical?
  end

  def test_breaking_returns_true_when_at_least_one_breaking_change
    result = GraphQL::SchemaComparator::Result.new([
      GraphQL::SchemaComparator::Changes::FieldRemoved.new(GraphQL::ObjectType.new, GraphQL::Field.new)
    ])
    assert_equal true, result.breaking?
  end

  def test_breaking_returns_false_when_no_breaking_changes
    result = GraphQL::SchemaComparator::Result.new([
      GraphQL::SchemaComparator::Changes::FieldAdded.new(GraphQL::ObjectType.new, GraphQL::Field.new)
    ])
    assert_equal false, result.breaking?
  end

  def test_breaking_changes
    enum_value_added = GraphQL::SchemaComparator::Changes::EnumValueAdded.new(GraphQL::EnumType.new, GraphQL::EnumType::EnumValue.new)
    field_added = GraphQL::SchemaComparator::Changes::FieldAdded.new(GraphQL::ObjectType.new, GraphQL::Field.new)
    field_removed = GraphQL::SchemaComparator::Changes::FieldRemoved.new(GraphQL::ObjectType.new, GraphQL::Field.new)
    type_description_changed = GraphQL::SchemaComparator::Changes::TypeDescriptionChanged.new(GraphQL::ObjectType.new, GraphQL::ObjectType.new)

    result = GraphQL::SchemaComparator::Result.new([
      enum_value_added,
      field_added,
      field_removed,
      type_description_changed
    ])

    assert_equal [field_removed], result.breaking_changes
  end

  def test_dangerous_changes
    enum_value_added = GraphQL::SchemaComparator::Changes::EnumValueAdded.new(GraphQL::EnumType.new, GraphQL::EnumType::EnumValue.new)
    field_added = GraphQL::SchemaComparator::Changes::FieldAdded.new(GraphQL::ObjectType.new, GraphQL::Field.new)
    field_removed = GraphQL::SchemaComparator::Changes::FieldRemoved.new(GraphQL::ObjectType.new, GraphQL::Field.new)
    type_description_changed = GraphQL::SchemaComparator::Changes::TypeDescriptionChanged.new(GraphQL::ObjectType.new, GraphQL::ObjectType.new)

    result = GraphQL::SchemaComparator::Result.new([
      enum_value_added,
      field_added,
      field_removed,
      type_description_changed
    ])

    assert_equal [field_removed], result.breaking_changes
  end

  def test_non_breaking_changes
    field_added = GraphQL::SchemaComparator::Changes::FieldAdded.new(GraphQL::ObjectType.new, GraphQL::Field.new)
    enum_value_added = GraphQL::SchemaComparator::Changes::EnumValueAdded.new(GraphQL::EnumType.new, GraphQL::EnumType::EnumValue.new)
    field_removed = GraphQL::SchemaComparator::Changes::FieldRemoved.new(GraphQL::ObjectType.new, GraphQL::Field.new)
    type_description_changed = GraphQL::SchemaComparator::Changes::TypeDescriptionChanged.new(GraphQL::ObjectType.new, GraphQL::ObjectType.new)

    result = GraphQL::SchemaComparator::Result.new([
      enum_value_added,
      field_added,
      field_removed,
      type_description_changed
    ])

    assert_equal [field_added, type_description_changed], result.non_breaking_changes
  end
end
