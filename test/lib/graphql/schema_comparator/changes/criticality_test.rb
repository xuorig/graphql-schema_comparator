require "test_helper"

class GraphQL::SchemaComparator::Changes::CriticalityTest < Minitest::Test
  def test_breaking_change
    breaking_change = GraphQL::SchemaComparator::Changes::Criticality.breaking

    assert breaking_change.breaking?
    assert_equal "This change is a breaking change", breaking_change.reason
  end

  def test_dangerous_change
    dangerous_change = GraphQL::SchemaComparator::Changes::Criticality.dangerous

    assert dangerous_change.dangerous?
    assert_equal "This change is dangerous", dangerous_change.reason
  end

  def test_non_breaking_change
    non_breaking_change = GraphQL::SchemaComparator::Changes::Criticality.non_breaking

    assert non_breaking_change.non_breaking?
    assert_equal "This change is safe", non_breaking_change.reason
  end

  def test_breaking_change_with_custom_reason
    breaking_change = GraphQL::SchemaComparator::Changes::Criticality.breaking(
      reason: "Breaking change because it would break everything"
    )

    assert breaking_change.breaking?
    assert_equal "Breaking change because it would break everything", breaking_change.reason
  end

  def test_dangerous_change_with_custom_reason
    dangerous_change = GraphQL::SchemaComparator::Changes::Criticality.dangerous(
      reason: "Dangerous because clients would be mad"
    )

    assert dangerous_change.dangerous?
    assert_equal "Dangerous because clients would be mad", dangerous_change.reason
  end

  def test_non_breaking_change_with_custom_reason
    non_breaking_change = GraphQL::SchemaComparator::Changes::Criticality.non_breaking(
      reason: "Perfectly fine"
    )

    assert non_breaking_change.non_breaking?
    assert_equal "Perfectly fine", non_breaking_change.reason
  end
end
