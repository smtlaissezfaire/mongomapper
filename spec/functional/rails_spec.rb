require 'spec_helper'

describe "Documents with the Rails plugin" do
  before do
    @doc_klass = Doc do
      key :foo, String
      key :long_field, String, :alias => "lf"
    end
  end

  context "with values from the DB" do
    before do
      @doc = @doc_klass.create(:foo => "bar", :long_field => "long value")
    end

    it "should have x_before_type_cast" do
      @doc.foo_before_type_cast.should == "bar"
    end

    it "should have x_before_type_cast for aliased fields" do
      @doc.long_field_before_type_cast.should == "long value"
    end

    it "should honor app-set values over DB-set values" do
      @doc.foo = nil
      @doc.foo_before_type_cast.should == nil
    end
  end

  context "when blank" do
    before do
      @doc = @doc_klass.create()
    end

    it "should have x_before_type_cast" do
      @doc.foo_before_type_cast.should == nil
    end

    it "should honor app-set values over DB-set values" do
      @doc.foo = nil
      @doc.foo_before_type_cast.should == nil

      @doc.foo = :baz
      @doc.foo_before_type_cast.should == :baz

      @doc.save
      @doc.reload.foo_before_type_cast.should == "baz"
    end
  end

  context "#has_one" do
    before do
      @doc_klass = Doc do
        has_one :foo
      end
    end

    it "should create a one association" do
      @doc_klass.associations.should have_key :foo
      @doc_klass.associations[:foo].should be_a MongoMapper::Plugins::Associations::OneAssociation
    end
  end
end
