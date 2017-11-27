require "test_helper"

describe GraphQL::SchemaComparator::Diff::InputField do
  let(:type) do
    GraphQL::InputObjectType.define do
      name "Input"
    end
  end

  let(:differ) { GraphQL::SchemaComparator::Diff::InputField.new(type, type, old_input_field, new_input_field) }
  let(:changes) { differ.diff }
  let(:change) { differ.diff.first }

  describe "#diff" do
    describe "input field type change" do
      let(:old_input_field) do
        GraphQL::Argument.define do
          name "foo"
          type types.String
        end
      end

      let(:new_input_field) do
        old_input_field.redefine { type types.Boolean }
      end

      it "is a breaking change" do
        assert_equal 1, changes.size
        assert change.breaking?

        assert_equal "Input field `Input.foo` changed type from `String` to `Boolean`", change.message
      end
    end

    describe "input field type change from scalar to list of the same type" do
      let(:old_input_field) do
        GraphQL::Argument.define do
          name "arg"
          type types[types.String]
        end
      end

      let(:new_input_field) do
        old_input_field.redefine { type types.String }
      end

      it "is a non-breaking change" do
        assert_equal 1, changes.size
        assert change.breaking?

        assert_equal "Input field `Input.arg` changed type from `[String]` to `String`", change.message
      end
    end

    describe "input field type change from non-null to null of the same underyling type" do
      let(:old_input_field) do
        GraphQL::Argument.define do
          name "arg"
          type !types.String
        end
      end

      let(:new_input_field) do
        old_input_field.redefine { type types.String }
      end

      it "is a non-breaking change" do
        assert_equal 1, changes.size
        refute change.breaking?

        assert_equal "Input field `Input.arg` changed type from `String!` to `String`", change.message
      end
    end

    describe "input field type change from null to non-null of the same underyling type" do
      let(:old_input_field) do
        GraphQL::Argument.define do
          name "arg"
          type types.String
        end
      end

      let(:new_input_field) do
        old_input_field.redefine { type !types.String }
      end

      it "is a breaking change" do
        assert change.breaking?
        assert_equal 1, changes.size
        assert_equal "Input field `Input.arg` changed type from `String` to `String!`", change.message
      end
    end

    describe "input field type nullability change on lists of the same underlying types" do
      let(:old_input_field) do
        GraphQL::Argument.define do
          name "arg"
          type !types[types.String]
        end
      end

      let(:new_input_field) do
        old_input_field.redefine { type types[types.String] }
      end

      it "is a non-breaking chnage" do
        assert_equal 1, changes.size
        refute change.breaking?

        assert_equal "Input field `Input.arg` changed type from `[String]!` to `[String]`", change.message
      end
    end

    describe "input field type change within lists of the same underyling types" do
      let(:old_input_field) do
        GraphQL::Argument.define do
          name "arg"
          type !types[!types.String]
        end
      end

      let(:new_input_field) do
        old_input_field.redefine { type !types[types.String] }
      end

      it "is a non-breaking change" do
        assert_equal 1, changes.size
        refute change.breaking?

        assert_equal "Input field `Input.arg` changed type from `[String!]!` to `[String]!`", change.message
      end
    end

    describe "input field type changes on and within lists of the same underlying types" do
      let(:old_input_field) do
        GraphQL::Argument.define do
          name "arg"
          type !types[!types.String]
        end
      end

      let(:new_input_field) do
        old_input_field.redefine { type types[types.String] }
      end

      it "is a non-breaking change" do
        assert_equal 1, changes.size
        refute change.breaking?

        assert_equal "Input field `Input.arg` changed type from `[String!]!` to `[String]`", change.message
      end
    end

    describe "input field type changes on and within lists of different underlying types" do
      let(:old_input_field) do
        GraphQL::Argument.define do
          name "arg"
          type !types[!types.String]
        end
      end

      let(:new_input_field) do
        old_input_field.redefine { type types[types.Boolean] }
      end

      it "is a breaking change" do
        assert_equal 1, changes.size
        assert change.breaking?

        assert_equal "Input field `Input.arg` changed type from `[String!]!` to `[Boolean]`", change.message
      end
    end
  end
end
