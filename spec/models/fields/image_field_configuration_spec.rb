require 'spec_helper'

describe Features::ImageFeatureConfiguration do

  let(:node_type) { Fabricate(:node_type) }
  let(:conf) { Fabricate.build(:image_fc) }

  before do
    conf.node_type = node_type
  end

  subject { conf }

  it { should respond_to :maximum_image }
  it { should respond_to :build_assoc! }
  it { should be_new_record }
  it { should be_valid }

  context "#configuration class" do
    specify { subject.class.superclass.should == Features::FeatureConfiguration }
  end

  context "#feature_class" do
    specify { subject.feature_class.should == Features::ImageFeature }
  end

  context "#partial_dir" do
    specify { subject.partial_dir.should == "features/image" }
  end

  context "#humanize_feature_name" do
    specify { subject.humanize_feature_name.should == "Image" }
  end
end