module GraphQL
  module SchemaComparator
    class Result
      attr_reader :changes, :breaking_changes, :non_breaking_changes

      def initialize(changes)
        @changes = changes.sort_by { |c| [c.breaking ? 1 : 2, c.message] }
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
