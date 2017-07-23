module GraphQL
  module SchemaComparator
    class Result
      attr_reader :changes

      def initialize(changes)
        @changes = changes
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
