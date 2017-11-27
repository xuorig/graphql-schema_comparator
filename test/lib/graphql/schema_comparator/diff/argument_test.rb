require "test_helper"

describe GraphQL::SchemaComparator::Diff::Argument do
  let(:type) do
    arg = old_argument

    GraphQL::ObjectType.define do
      name "Query"
      field :a do
        argument arg
      end
    end
  end

  let(:field) do
    type.fields["a"]
  end

  let(:differ) { GraphQL::SchemaComparator::Diff::Argument.new(type, field, old_argument, new_argument) }
  let(:changes) { differ.diff }
  let(:change) { differ.diff.first }

  describe "#diff" do
    describe "argument type change" do
      let(:old_argument) do
        GraphQL::Argument.define do
          name "arg"
          type types.String
        end
      end

      let(:new_argument) do
        old_argument.redefine { type types.Boolean }
      end

      it "is a breaking change" do
        assert_equal 1, changes.size
        assert change.breaking?

        assert_equal "Type for argument `arg` on field `Query.a` changed from `String` to `Boolean`", change.message
      end
    end

    describe "argument type change from scalar to list of the same type" do
      let(:old_argument) do
        GraphQL::Argument.define do
          name "arg"
          type types[types.String]
        end
      end

      let(:new_argument) do
        old_argument.redefine { type types.String }
      end

      it "is a non-breaking change" do
        assert_equal 1, changes.size
        assert change.breaking?

        assert_equal "Type for argument `arg` on field `Query.a` changed from `[String]` to `String`", change.message
      end
    end

    describe "argument type change from non-null to null of the same underyling type" do
      let(:old_argument) do
        GraphQL::Argument.define do
          name "arg"
          type !types.String
        end
      end

      let(:new_argument) do
        old_argument.redefine { type types.String }
      end

      it "is a non-breaking change" do
        assert_equal 1, changes.size
        refute change.breaking?

        assert_equal "Type for argument `arg` on field `Query.a` changed from `String!` to `String`", change.message
      end
    end

    describe "argument type change from null to non-null of the same underyling type" do
      let(:old_argument) do
        GraphQL::Argument.define do
          name "arg"
          type types.String
        end
      end

      let(:new_argument) do
        old_argument.redefine { type !types.String }
      end

      it "is a breaking change" do
        assert change.breaking?
        assert_equal 1, changes.size
        assert_equal "Type for argument `arg` on field `Query.a` changed from `String` to `String!`", change.message
      end
    end

    describe "argument type nullability change on lists of the same underlying types" do
      let(:old_argument) do
        GraphQL::Argument.define do
          name "arg"
          type !types[types.String]
        end
      end

      let(:new_argument) do
        old_argument.redefine { type types[types.String] }
      end

      it "is a non-breaking chnage" do
        assert_equal 1, changes.size
        refute change.breaking?

        assert_equal "Type for argument `arg` on field `Query.a` changed from `[String]!` to `[String]`", change.message
      end
    end

    describe "argument type change within lists of the same underyling types" do
      let(:old_argument) do
        GraphQL::Argument.define do
          name "arg"
          type !types[!types.String]
        end
      end

      let(:new_argument) do
        old_argument.redefine { type !types[types.String] }
      end

      it "is a non-breaking change" do
        assert_equal 1, changes.size
        refute change.breaking?

        assert_equal "Type for argument `arg` on field `Query.a` changed from `[String!]!` to `[String]!`", change.message
      end
    end

    describe "argument type changes on and within lists of the same underlying types" do
      let(:old_argument) do
        GraphQL::Argument.define do
          name "arg"
          type !types[!types.String]
        end
      end

      let(:new_argument) do
        old_argument.redefine { type types[types.String] }
      end

      it "is a non-breaking change" do
        assert_equal 1, changes.size
        refute change.breaking?

        assert_equal "Type for argument `arg` on field `Query.a` changed from `[String!]!` to `[String]`", change.message
      end
    end

    describe "argument type changes on and within lists of different underlying types" do
      let(:old_argument) do
        GraphQL::Argument.define do
          name "arg"
          type !types[!types.String]
        end
      end

      let(:new_argument) do
        old_argument.redefine { type types[types.Boolean] }
      end

      it "is a breaking change" do
        assert_equal 1, changes.size
        assert change.breaking?

        assert_equal "Type for argument `arg` on field `Query.a` changed from `[String!]!` to `[Boolean]`", change.message
      end
    end
  end
end
