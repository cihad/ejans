require 'spec_helper'

describe Features::ListFeatureConfiguration do

  let(:node_type) { Fabricate(:node_type) }
  let(:conf) { Fabricate.build(:list_fc) }
  let(:blank_query) { BlankCriteria.new }  

  before do
    conf.node_type = node_type
  end

  subject { conf }

  it { should respond_to :maximum_select }
  it { should respond_to :list_items }
  it { should respond_to :build_assoc! }
  it { should respond_to :filter_query }
  it { should be_new_record }
  it { should be_valid }

  context "#configuration class" do
    specify { subject.class.superclass.should == Features::FeatureConfiguration }
  end

  context "#feature_class" do
    specify { subject.feature_class.should == Features::ListFeature }
  end

  context "#partial_dir" do
    specify { subject.partial_dir.should == "features/list" }
  end

  context "#humanize_feature_name" do
    specify { subject.humanize_feature_name.should == "List" }
  end

  context "#filter_query" do
    context "when params is empty" do
      let(:params) { {} }

      specify do
        subject.filter_query(params).should == blank_query
      end
    end

    context "when params is filled" do
      before do
        subject.save
      end

      let(:params) { { subject.machine_name => [subject.list_items.first.id.to_s] } }
      specify do
        subject.filter_query(params).should ==
          blank_query.in(
            :"features.#{conf.keyname.to_s.singularize}_ids" =>
              [subject.list_items.first.id]
          )
      end
    end
  end

  context "when conf's filter is true" do
    before do
      conf.filter = true
      conf.save
    end

    specify { node_type.filters.should include(conf) }
  end

  context "data names" do
    it "should include value singularize name" do
      subject.maximum_select = 1
      subject.data_names.should be_include(:"#{subject.machine_name}_value")
    end

    it "should include values pluralize name" do
      subject.maximum_select = 2
      subject.data_names.should be_include(:"#{subject.machine_name}_values")
    end
  end
end