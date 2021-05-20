require "test_helper"

class GraphQL::SchemaComparator::Diff::DirectiveTest < Minitest::Test
  def setup
    @old_directive = GraphQL::Directive.define do
      name "Default"
      argument :a, types.Int, default_value: "No", description: "A Description"
      argument :b, types.String
      locations [:QUERY, :MUTATION]
    end

    @new_directive = GraphQL::Directive.define do
      name "Default"
      argument :a, types.String, default_value: "Yes", description: "Another Description"
      argument :c, types.String
      locations [:MUTATION, :SUBSCRIPTION]
    end

     @differ = GraphQL::SchemaComparator::Diff::Directive.new(@old_directive, @new_directive)
  end

  def test_diff
    assert_equal [
      "Location `QUERY` was removed from directive `Default`",
      "Location `SUBSCRIPTION` was added to directive `Default`",
      "Argument `c` was added to directive `Default`",
      "Argument `b` was removed from directive `Default`",
      "Description for argument `a` on directive `Default` changed from `A Description` to `Another Description`",
      "Default value for argument `a` on directive `Default` changed from `No` to `Yes`",
      "Type for argument `a` on directive `Default` changed from `Int` to `String`"
    ], @differ.diff.map(&:message)
  end
end
