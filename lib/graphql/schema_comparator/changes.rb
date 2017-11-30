require 'graphql/schema_comparator/changes/criticality'
require 'graphql/schema_comparator/changes/safe_type_change'
require 'graphql/schema_comparator/changes/breaking'
require 'graphql/schema_comparator/changes/dangerous'
require 'graphql/schema_comparator/changes/non_breaking'

module GraphQL
  module SchemaComparator
    module Changes

      class AbstractChange
        def message
          raise NotImplementedError
        end

        def breaking?
          raise NotImplementedError
        end

        def criticality
          raise NotImplementedError
        end
      end
    end
  end
end
