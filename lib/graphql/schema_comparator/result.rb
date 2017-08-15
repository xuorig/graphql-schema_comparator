module GraphQL
  module SchemaComparator
    class Result
      attr_reader :changes

      def initialize(changes)
        @changes = changes.sort_by { |c| [c.breaking ? 1 : 2, c.message] }
      end

      def identical?
        @changes.empty?
      end

      def breaking_changes
        @changes.select { |c| c.breaking }
      end

      def breaking?
        @changes.any? { |c| c.breaking }
      end
    end
  end
end
