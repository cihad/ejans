require 'spec_helper'

describe Features::StringFeatureConfiguration do

  let(:node_type) { Fabricate(:node_type) }
  let(:conf) { Fabricate.build(:string_fc) }

  before do
    conf.node_type = node_type
  end

  subject { conf }

  it { should respond_to :row }
  it { should respond_to :minimum_length }
  it { should respond_to :maximum_length }
  it { should respond_to :text_format }
  it { should respond_to :build_assoc! }
  it { should be_new_record }
  it { should be_valid }

  context "#configuration class" do
    specify { subject.class.superclass.should == Features::FeatureConfiguration }
  end

  context "#feature_class" do
    specify { subject.feature_class.should == Features::StringFeature }
  end

  context "#partial_dir" do
    specify { subject.partial_dir.should == "features/string" }
  end

  context "#humanize_feature_name" do
    specify { subject.humanize_feature_name.should == "String" }
  end

  context "text_formal is invalid attribute" do
    before do
      subject.text_format = :invalid_attribute
    end

    it { should_not be_valid }
  end
end