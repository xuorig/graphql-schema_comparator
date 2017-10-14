require "test_helper"

describe GraphQL::SchemaComparator::Diff::Directive do
  let(:old_directive) do
    GraphQL::Directive.define do
      name "Default"
      argument :a, types.Int, default_value: "No", description: "A Description"
      argument :b, types.String
      locations [:QUERY, :MUTATION]
    end
  end

  let(:new_directive) do
    GraphQL::Directive.define do
      name "Default"
      argument :a, types.String, default_value: "Yes", description: "Another Description"
      argument :c, types.String
      locations [:MUTATION, :SUBSCRIPTION]
    end
  end

  let(:differ) { GraphQL::SchemaComparator::Diff::Directive.new(old_directive, new_directive) }

  describe "#diff" do
    it "returns a list of changes between directives" do
      assert_equal [
        "Location `QUERY` was removed from directive `Default`",
        "Location `SUBSCRIPTION` was added to directive `Default`",
        "Argument `c` was added to directive `Default`",
        "Argument `b` was removed from directive `Default`",
        "Description for argument `a` on directive `Default` changed from `Another Description` to `A Description`",
        "Default value for argument `a` on directive `Default` changed from `Yes` to `No`",
        "Type for argument `a` on directive `Default` changed from `String` to `Int`"
      ], differ.diff.map(&:message)
    end
  end
end
