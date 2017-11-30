require "test_helper"

describe GraphQL::SchemaComparator::Diff::Field do
  let(:type) do
    GraphQL::ObjectType.define do
      name "Foo"
    end
  end

  let(:differ) { GraphQL::SchemaComparator::Diff::Field.new(type, type, old_field, new_field) }
  let(:changes) { differ.diff }
  let(:change) { differ.diff.first }

  describe "#diff" do
    describe "field type change" do
      let(:old_field) do
        GraphQL::Field.define do
          name "foo"
          type types.String
        end
      end

      let(:new_field) do
        old_field.redefine { type types.Boolean }
      end

      it "is a breaking change" do
        assert_equal 1, changes.size
        assert change.breaking?

        assert_equal "Field `Foo.foo` changed type from `String` to `Boolean`", change.message
      end
    end

    describe "field type change from scalar to list of the same type" do
      let(:old_field) do
        GraphQL::Field.define do
          name "bar"
          type types[types.String]
        end
      end

      let(:new_field) do
        old_field.redefine { type types.String }
      end

      it "is a non-breaking change" do
        assert_equal 1, changes.size
        assert change.breaking?

        assert_equal "Field `Foo.bar` changed type from `[String]` to `String`", change.message
      end
    end

    describe "field type change from non-null to null of the same underyling type" do
      let(:old_field) do
        GraphQL::Field.define do
          name "bar"
          type !types.String
        end
      end

      let(:new_field) do
        old_field.redefine { type types.String }
      end

      it "is a breaking change" do
        assert_equal 1, changes.size
        assert change.breaking?

        assert_equal "Field `Foo.bar` changed type from `String!` to `String`", change.message
      end
    end

    describe "field type change from null to non-null of the same underyling type" do
      let(:old_field) do
        GraphQL::Field.define do
          name "bar"
          type types.String
        end
      end

      let(:new_field) do
        old_field.redefine { type !types.String }
      end

      it "is a non-breaking change" do
        assert_equal 1, changes.size
        refute change.breaking?

        assert_equal "Field `Foo.bar` changed type from `String` to `String!`", change.message
      end
    end

    describe "field type nullability change on lists of the same underlying types" do
      let(:old_field) do
        GraphQL::Field.define do
          name "bar"
          type !types[types.String]
        end
      end

      let(:new_field) do
        old_field.redefine { type types[types.String] }
      end

      it "is a breaking chnage" do
        assert_equal 1, changes.size
        assert change.breaking?

        assert_equal "Field `Foo.bar` changed type from `[String]!` to `[String]`", change.message
      end
    end

    describe "field type change within lists of the same underyling types" do
      let(:old_field) do
        GraphQL::Field.define do
          name "bar"
          type !types[!types.String]
        end
      end

      let(:new_field) do
        old_field.redefine { type !types[types.String] }
      end

      it "is a breaking change" do
        assert_equal 1, changes.size
        assert change.breaking?

        assert_equal "Field `Foo.bar` changed type from `[String!]!` to `[String]!`", change.message
      end
    end

    describe "field type changes on and within lists of the same underlying types" do
      let(:old_field) do
        GraphQL::Field.define do
          name "bar"
          type !types[!types.String]
        end
      end

      let(:new_field) do
        old_field.redefine { type types[types.String] }
      end

      it "is a breaking change" do
        assert_equal 1, changes.size
        assert change.breaking?

        assert_equal "Field `Foo.bar` changed type from `[String!]!` to `[String]`", change.message
      end
    end

    describe "field type changes on and within lists of different underlying types" do
      let(:old_field) do
        GraphQL::Field.define do
          name "bar"
          type !types[!types.String]
        end
      end

      let(:new_field) do
        old_field.redefine { type types[types.Boolean] }
      end

      it "is a breaking change" do
        assert_equal 1, changes.size
        assert change.breaking?

        assert_equal "Field `Foo.bar` changed type from `[String!]!` to `[Boolean]`", change.message
      end
    end
  end
end
