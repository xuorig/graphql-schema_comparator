module GraphQL
  module SchemaComparator
    class Result
      attr_reader :changes, :breaking_changes, :non_breaking_changes

      def initialize(changes)
        @changes = changes
        @breaking_changes, @non_breaking_changes = @changes.partition(&:breaking)
      end

      def identical?
        @changes.empty?
      end

      def breaking?
        breaking_changes.any?
      end
    end
  end
end
