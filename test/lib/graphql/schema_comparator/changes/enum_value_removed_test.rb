require "test_helper"

class GraphQL::SchemaComparator::Changes::EnumValueRemovedTest < Minitest::Test
  class ProgrammingLanguageEnum < GraphQL::Schema::Enum
    value 'PYTHON'
    value 'RUBY'
    value 'JAVASCRIPT'
  end

  def test_with_input_usage
    change = GraphQL::SchemaComparator::Changes::EnumValueRemoved.new(
      ProgrammingLanguageEnum,
      ProgrammingLanguageEnum.values['JAVASCRIPT'],
      GraphQL::SchemaComparator::EnumUsage.new(input: true, output: false)
    )

    assert change.breaking?
  end

  def test_with_output_usage
    change = GraphQL::SchemaComparator::Changes::EnumValueRemoved.new(
      ProgrammingLanguageEnum,
      ProgrammingLanguageEnum.values['JAVASCRIPT'],
      GraphQL::SchemaComparator::EnumUsage.new(input: false, output: true)
    )

    assert change.non_breaking?
  end
end
