require "test_helper"

describe GraphQL::SchemaComparator::Diff::Directive do
  let(:old_enum) do
    GraphQL::EnumType.define do
      name "Languages"
      description "Programming languages for Web projects"
      value("PYTHON", "A dynamic, function-oriented language", deprecation_reason: "a")
      value("RUBY", "A very dynamic language aimed at programmer happiness")
      value("JAVASCRIPT", "Accidental lingua franca of the web")
    end
  end

  let(:new_enum) do
    GraphQL::EnumType.define do
      name "Languages"
      description "Programming languages for all projects"
      value("PYTHON", "A dynamic, function-oriented language", deprecation_reason: "b")
      value("JAVASCRIPT", "Accidental lingua franca of the web lol", deprecation_reason: "Because!")
      value("CPLUSPLUS", "iamverysmart")
    end
  end

  let(:differ) { GraphQL::SchemaComparator::Diff::Enum.new(old_enum, new_enum) }

  describe "#diff" do
    it "returns a list of changes between enums" do
      assert_equal [
        "Enum value `RUBY` was removed from enum `Languages`",
        "Enum value `CPLUSPLUS` was added to enum `Languages`",
        "Enum value `Languages.PYTHON` deprecation reason changed from `a` to `b`",
        "Description for enum value `Languages.JAVASCRIPT` changed from `Accidental lingua franca of the web` to `Accidental lingua franca of the web lol`",
        "Enum value `Languages.JAVASCRIPT` was deprecated with reason `Because!`",
      ], differ.diff.map(&:message)
    end
  end
end
