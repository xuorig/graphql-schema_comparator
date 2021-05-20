module GraphQL
  module SchemaComparator
    module Diff
      class DirectiveArgument
        def initialize(directive, old_arg, new_arg)
          @directive = directive
          @old_arg = old_arg
          @new_arg = new_arg
        end

        def diff
          changes = []

          if old_arg.description != new_arg.description
            changes << Changes::DirectiveArgumentDescriptionChanged.new(directive, old_arg, new_arg)
          end

          if old_arg.default_value != new_arg.default_value
            changes << Changes::DirectiveArgumentDefaultChanged.new(directive, old_arg, new_arg)
          end

          if old_arg.type.graphql_definition != new_arg.type.graphql_definition
            changes << Changes::DirectiveArgumentTypeChanged.new(directive, old_arg, new_arg)
          end

          # TODO directives on directive arguments

          changes
        end

        private

        attr_reader(:directive, :new_arg, :old_arg)
      end
    end
  end
end
