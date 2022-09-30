require "test_helper"

class GraphQL::SchemaComparator::Changes::EnumValueAddedTest < Minitest::Test
  class ProgrammingLanguageEnum < GraphQL::Schema::Enum
    value 'PYTHON'
    value 'RUBY'
    value 'JAVASCRIPT'
  end

  def test_with_input_usage
    change = GraphQL::SchemaComparator::Changes::EnumValueAdded.new(
      ProgrammingLanguageEnum,
      ProgrammingLanguageEnum.values['RUBY'],
      GraphQL::SchemaComparator::EnumUsage.new(input: true, output: false)
    )

    assert change.non_breaking?
  end

  def test_with_output_usage
    change = GraphQL::SchemaComparator::Changes::EnumValueAdded.new(
      ProgrammingLanguageEnum,
      ProgrammingLanguageEnum.values['RUBY'],
      GraphQL::SchemaComparator::EnumUsage.new(input: false, output: true)
    )

    assert change.dangerous?
  end
end
