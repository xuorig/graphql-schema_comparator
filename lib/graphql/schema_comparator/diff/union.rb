module GraphQL
  module SchemaComparator
    module Diff
      class Union
        def initialize(old_type, new_type)
          @old_type = old_type
          @new_type = new_type

          @old_possible_types = old_type.possible_types
          @new_possible_types = new_type.possible_types
        end

        def diff
          changes = []
          changes += removed_possible_types.map do |removed|
            Changes::UnionMemberRemoved.new(new_type, removed)
          end
          changes += added_possible_types.map do |added|
            Changes::UnionMemberAdded.new(new_type, added)
          end
          changes
        end

        private

        attr_reader :old_type, :new_type, :old_possible_types, :new_possible_types

        def removed_possible_types
          old_possible_types.select { |type| !new_possible_types.include?(type) }
        end

        def added_possible_types
          new_possible_types.select { |type| !old_possible_types.include?(type) }
        end
      end
    end
  end
end
