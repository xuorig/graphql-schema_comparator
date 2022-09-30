module GraphQL
  module SchemaComparator
    class EnumUsage
      def initialize(input:, output:)
        @input = input
        @output = output
      end

      def input?
        @input
      end

      def output?
        @output
      end
    end
  end
end
