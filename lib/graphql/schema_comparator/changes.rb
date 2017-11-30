require 'graphql/schema_comparator/changes/criticality'
require 'graphql/schema_comparator/changes/breaking'
require 'graphql/schema_comparator/changes/dangerous'
require 'graphql/schema_comparator/changes/non_breaking'


module GraphQL
  module SchemaComparator
    module Changes
      module SafeTypeChange
        def safe_change?(old_type, new_type)
          if !old_type.kind.wraps? && !new_type.kind.wraps?
            old_type == new_type
          elsif old_type.kind.list? && new_type.kind.list?
            safe_change?(old_type.of_type, new_type.of_type)
          elsif old_type.kind.non_null?
            of_type = new_type.kind.non_null? ? new_type.of_type : new_type
            safe_change?(old_type.of_type, of_type)
          else
            false
          end
        end
      end

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
