module GraphQL
  module SchemaComparator
    module Diff
      class Enum
        def initialize(old_enum, new_enum, usage)
          @old_enum = old_enum
          @new_enum = new_enum

          @old_values = old_enum.values
          @new_values = new_enum.values

          @usage = usage
        end

        def diff
          changes = []

          changes += removed_values.map { |value| Changes::EnumValueRemoved.new(old_enum, value, usage) }
          changes += added_values.map { |value| Changes::EnumValueAdded.new(new_enum, value, usage) }

          each_common_value do |old_value, new_value|
            # TODO: Add Directive Stuff

            if old_value.description != new_value.description
              changes << Changes::EnumValueDescriptionChanged.new(new_enum, old_value, new_value)
            end

            if old_value.deprecation_reason != new_value.deprecation_reason
              changes << Changes::EnumValueDeprecated.new(new_enum, old_value, new_value)
            end
          end

          changes
        end

        private

        attr_reader :old_enum, :new_enum, :old_values, :new_values, :usage

        def each_common_value(&block)
          intersection = old_values.keys & new_values.keys
          intersection.each do |common_value|
            old_value = old_enum.values[common_value]
            new_value = new_enum.values[common_value]

            block.call(old_value, new_value)
          end
        end

        def removed_values
          (old_values.keys - new_values.keys).map { |removed| old_enum.values[removed] }
        end

        def added_values
          (new_values.keys - old_values.keys).map { |added| new_enum.values[added] }
        end
      end
    end
  end
end
