module GraphQL
  module SchemaComparator
    # The result of a comparison between two schema versions
    class Result
      attr_reader :changes, :breaking_changes, :non_breaking_changes, :dangerous_changes

      def initialize(changes)
        @changes = changes.sort_by(&:criticality).reverse
        @breaking_changes = @changes.select(&:breaking?)
        @non_breaking_changes = @changes.select(&:non_breaking?)
        @dangerous_changes = @changes.select(&:dangerous?)
      end

      # If the two schemas were identical
      # @return [Boolean]
      def identical?
        @changes.empty?
      end

      # If there was a breaking change between the two schema versions
      # @return [Boolean]
      def breaking?
        breaking_changes.any?
      end
    end
  end
end
