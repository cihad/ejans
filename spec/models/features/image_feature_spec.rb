require 'spec_helper'

describe Features::ImageFeature do
  let(:node_type) { Fabricate(:node_type) }
  let(:node) { Fabricate.build(:node) }
  let(:conf) { Fabricate.build(:image_fc) }

  before do
    node_type.feature_configurations << conf
    conf.save
    node.node_type = node_type
    node.save
    feature = node.features.first
  end

  subject do
    node.features.first
  end

  it { should respond_to :value }
  it { should respond_to conf.key_name }
  it { should be_valid }

  context "should be exists has_and_belongs_to_many association by key_name" do 
    specify do
      subject.class.
        reflect_on_association(conf.key_name).
        should_not be_nil
    end

    specify do
      subject.class.
        reflect_on_association(conf.key_name).
        name.should == conf.key_name
    end
  end
end
