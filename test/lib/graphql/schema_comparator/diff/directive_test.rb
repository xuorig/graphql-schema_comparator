require "test_helper"

class GraphQL::SchemaComparator::Diff::DirectiveTest < Minitest::Test
  def test_diff
    old_directive = Class.new(GraphQL::Schema::Directive) do
      graphql_name "Default"
      argument :a, Integer, required: true, default_value: "No", description: "A Description"
      argument :b, String, required: true
      locations :QUERY, :MUTATION
    end

    new_directive = Class.new(GraphQL::Schema::Directive) do
      graphql_name "Default"
      argument :a, String, required: true, default_value: "Yes", description: "Another Description"
      argument :c, String, required: true
      locations :MUTATION, :SUBSCRIPTION
    end

    differ = GraphQL::SchemaComparator::Diff::Directive.new(old_directive, new_directive)

    assert_equal [
      "Location `QUERY` was removed from directive `Default`",
      "Location `SUBSCRIPTION` was added to directive `Default`",
      "Argument `c` was added to directive `Default`",
      "Argument `b` was removed from directive `Default`",
      "Description for argument `a` on directive `Default` changed from `A Description` to `Another Description`",
      "Default value for argument `a` on directive `Default` changed from `No` to `Yes`",
      "Type for argument `a` on directive `Default` changed from `Int!` to `String!`"
    ], differ.diff.map(&:message)

    assert_equal [
      "@Default",
      "@Default",
      "@Default.c",
      "@Default.b",
      "@Default.a",
      "@Default.a",
      "@Default.a"
    ], differ.diff.map(&:path)
  end
end
