require "test_helper"

class GraphQL::SchemaComparator::Changes::FieldAddedTest < Minitest::Test
  def test_criticality_is_non_breaking_by_default
    change = GraphQL::SchemaComparator::Changes::FieldAdded.new(
      GraphQL::ObjectType.define { name "Type" },
      GraphQL::Field.define { name "field" },
    )

    assert change.non_breaking?
  end

  def test_criticality_is_dangerous_for_id_field_addition
    change = GraphQL::SchemaComparator::Changes::FieldAdded.new(
      GraphQL::ObjectType.define { name "Type" },
      GraphQL::Field.define { name "id" },
    )

    assert change.dangerous?
    assert_equal 'this can blow up linters and change caching behaviour', change.message
  end
end
