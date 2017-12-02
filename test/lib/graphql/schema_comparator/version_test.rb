require "test_helper"

class GraphQL::SchemaComparator::VersionTest < Minitest::Test
  def test_has_version
    assert GraphQL::SchemaComparator::VERSION != nil
  end
end
