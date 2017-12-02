module GraphQL
  module SchemaComparator
    module Changes
      class Criticality
        NON_BREAKING = :NON_BREAKING
        DANGEROUS = :DANGEROUS
        BREAKING = :BREAKING

        attr_reader :level, :reason

        class << self
          def breaking(reason: "This change is a breaking change")
            new(
              level: BREAKING,
              reason: reason
            )
          end

          def non_breaking(reason: "This change is safe")
            new(
              level: NON_BREAKING,
              reason: reason
            )
          end

          def dangerous(reason: "This change is dangerous")
            new(
              level: DANGEROUS,
              reason: reason
            )
          end
        end

        def initialize(level: NON_BREAKING, reason: nil)
          @level = level
          @reason = reason
        end

        def breaking?
          @level == BREAKING
        end

        def non_breaking?
          @level == NON_BREAKING
        end

        def dangerous?
          @level == DANGEROUS
        end
      end
    end
  end
end
