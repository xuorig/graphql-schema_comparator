module GraphQL
  module SchemaComparator
    module Diff
      class Directive
        def initialize(old_directive, new_directive)
          @old_directive = old_directive
          @new_directive = new_directive
          @old_arguments = old_directive.arguments
          @new_arguments = new_directive.arguments
        end

        def diff
          changes = []

          if old_directive.description != new_directive.description
            changes << Changes::DirectiveDescriptionChanged.new(old_directive, new_directive)
          end

          changes += removed_locations.map { |location| Changes::DirectiveLocationRemoved.new(new_directive, location) }
          changes += added_locations.map { |location| Changes::DirectiveLocationAdded.new(new_directive, location) }
          changes += added_arguments.map { |argument| Changes::DirectiveArgumentAdded.new(new_directive, argument) }
          changes += removed_arguments.map { |argument| Changes::DirectiveArgumentRemoved.new(new_directive, argument) }

          each_common_argument do |old_argument, new_argument|
            changes += Diff::DirectiveArgument.new(new_directive, old_argument, new_argument).diff
          end

          changes
        end

        private

        def removed_locations
          (old_directive.locations - new_directive.locations)
        end

        def added_locations
          (new_directive.locations - old_directive.locations)
        end

        def removed_arguments
          old_arguments.values.select { |arg| !new_arguments[arg.graphql_name] }
        end

        def added_arguments
          new_arguments.values.select { |arg| !old_arguments[arg.graphql_name] }
        end

        def each_common_argument(&block)
          intersection = old_arguments.keys & new_arguments.keys
          intersection.each do |common_arg|
            old_arg = old_directive.arguments[common_arg]
            new_arg = new_directive.arguments[common_arg]

            block.call(old_arg, new_arg)
          end
        end

        attr_reader(:old_directive, :new_directive, :old_arguments, :new_arguments)
      end
    end
  end
end
