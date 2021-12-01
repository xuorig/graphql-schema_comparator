module GraphQL
  module SchemaComparator
    module Changes
      # Defines the criticality of a {Change} object.
      class Criticality
        # Non-breaking criticality usually defines changes that are always
        # safe to make to a GraphQL Schema. They do not
        # require any changes on the client side
        NON_BREAKING = 1

        # Dangerous criticality defines changes that are not breaking
        # the schema, but may break runtime logic on clients
        # if they did not code defensively enough to prevent
        # these changes.
        DANGEROUS = 2

        # Breaking criticality are changes that immediately impact
        # clients usually causing queries not to be valid anymore.
        BREAKING = 3

        attr_reader :level, :reason

        class << self
          # Returns a new Criticality object with a BREAKING level
          # @param reason [String] optional reason for this criticality
          # @return [GraphQL::SchemaComparator::Changes::Criticality]
          def breaking(reason: "This change is a breaking change")
            new(
              level: BREAKING,
              reason: reason
            )
          end

          # Returns a new Criticality object with a NON_BREAKING level
          # @param reason [String] optional reason for this criticality
          # @return [GraphQL::SchemaComparator::Changes::Criticality]
          def non_breaking(reason: "This change is safe")
            new(
              level: NON_BREAKING,
              reason: reason
            )
          end

          # Returns a new Criticality object with a DANGEROUS level
          # @param reason [String] optional reason for this criticality
          # @return [GraphQL::SchemaComparator::Changes::Criticality]
          def dangerous(reason: "This change is dangerous")
            new(
              level: DANGEROUS,
              reason: reason
            )
          end
        end

        # Creates a new Criticality object
        #
        # @param level [Symbol] The criticality level
        # @param reason [String] The reason why this criticality is set on the change
        def initialize(level: NON_BREAKING, reason: nil)
          @level = level
          @reason = reason
        end

        def <=>(other)
          if level == other.level
            0
          elsif level < other.level
            -1
          else
            1
          end
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
