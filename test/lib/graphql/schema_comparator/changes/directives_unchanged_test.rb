require "test_helper"

class GraphQL::SchemaComparator::Changes::DirectivesUnchangedTest < Minitest::Test
  def test_identical_schemas
    schema_idl = <<~SCHEMA
      schema {
        query: QueryRoot
      }
      
      type QueryRoot {
        name(locale: String = "en"): String!
      }
      
      directive @colorFormat(
        colorFormat: ColorFormatEnum!
      ) on QUERY
      
      enum ColorFormatEnum {
        HSL
        LCH
      }
    SCHEMA

    result = GraphQL::SchemaComparator.compare(schema_idl, schema_idl)

    assert_equal [], result.breaking_changes.map(&:message)
  end
end
