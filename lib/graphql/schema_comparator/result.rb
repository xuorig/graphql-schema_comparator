module GraphQL
  module SchemaComparator
    class Result
      attr_reader :changes, :breaking_changes, :non_breaking_changes, :dangerous_changes

      def initialize(changes)
        @changes = changes.sort_by do |change|
          if change.breaking?
            1
          elsif change.dangerous?
            2
          else
            3
          end
        end

        @breaking_changes = @changes.select(&:breaking?)
        @non_breaking_changes = @changes.select(&:non_breaking?)
        @dangerous_changes = @changes.select(&:dangerous?)
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
