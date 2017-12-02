module GraphQL
  module SchemaComparator
    module Changes
      class AbstractChange
        def message
          raise NotImplementedError
        end

        def breaking?
          criticality.breaking?
        end

        def dangerous?
          criticality.dangerous?
        end

        def non_breaking?
          criticality.non_breaking?
        end

        def criticality
          raise NotImplementedError
        end
      end
    end
  end
end
