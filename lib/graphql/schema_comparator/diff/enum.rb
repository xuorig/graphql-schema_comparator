module GraphQL
  module SchemaComparator
    module Diff
      class Enum
        def initialize(old_type, new_type)
          @old_type = old_type
          @new_type = new_type

          @old_values = old_type.values
          @new_values = new_type.values
        end

        def diff
          changes = []

          changes += removed_values.map { |value| Changes::EnumValueRemoved.new(old_type, value) }
          changes += added_values.map { |value| Changes::EnumValueAdded.new(new_type, value) }

          each_common_value do |old_value, new_value|
            # TODO: Add Directive Stuff

            if old_value.description != new_value.description
              changes += Changes::EnumValueDescriptionChanged.new(old_value, new_value)
            end

            if old_value.deprecation_reason != new_value.deprecation_reason
              changes += Changes::EnumValueDeprecated.new(old_value, new_value)
            end
          end

          changes
        end

        private

        attr_reader :old_type, :new_type, :old_values, :new_values

        def each_common_value(&block)
          intersection = old_values.keys & new_values.keys
          intersection.each do |common_value|
            old_value = old_type.values[common_value]
            new_value = new_type.values[common_value]

            block.call(old_value, new_value)
          end
        end

        def removed_values
          (old_values.keys - new_values.keys).map { |removed| old_type.values[removed] }
        end

        def added_values
          (new_values.keys - old_values.keys).map { |added| new_type.values[added] }
        end
      end
    end
  end
end
