require "test_helper"

class GraphQL::SchemaComparator::Diff::EnumTest < Minitest::Test
  def setup
    @old_enum = GraphQL::EnumType.define do
     name "Languages"
     description "Programming languages for Web projects"
     value("PYTHON", "A dynamic, function-oriented language", deprecation_reason: "a")
     value("RUBY", "A very dynamic language aimed at programmer happiness")
     value("JAVASCRIPT", "Accidental lingua franca of the web")
    end

    @new_enum = GraphQL::EnumType.define do
     name "Languages"
     description "Programming languages for all projects"
     value("PYTHON", "A dynamic, function-oriented language", deprecation_reason: "b")
     value("JAVASCRIPT", "Accidental lingua franca of the web lol", deprecation_reason: "Because!")
     value("CPLUSPLUS", "iamverysmart")
    end

    @differ = GraphQL::SchemaComparator::Diff::Enum.new(@old_enum, @new_enum)
  end

  def test_diff
    assert_equal [
     "Enum value `RUBY` was removed from enum `Languages`",
     "Enum value `CPLUSPLUS` was added to enum `Languages`",
     "Enum value `Languages.PYTHON` deprecation reason changed from `a` to `b`",
     "Description for enum value `Languages.JAVASCRIPT` changed from `Accidental lingua franca of the web` to `Accidental lingua franca of the web lol`",
     "Enum value `Languages.JAVASCRIPT` was deprecated with reason `Because!`",
    ], @differ.diff.map(&:message)
  end
end
