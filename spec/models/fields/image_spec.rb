require 'spec_helper'

describe Features::Image do
  let(:node_type) { Fabricate(:node_type) }
  let(:node) { Fabricate.build(:node) }
  let(:conf) { Fabricate.build(:image_fc) }
  let(:image) { Fabricate.build(:image_800_600) }

  before do
    node_type.feature_configurations << conf
    conf.save
    node.node_type = node_type
    node.save
    feature = node.features.first
    feature.class.set_specify(conf)
    feature.send(conf.keyname).push(image)
  end

  subject do
    image
  end

  it { should respond_to :image }
  it { should respond_to :position }
  it { should be_valid }

  context "image versions" do
    it "#thumb" do
      subject.image_url(:thumb).should be_kind_of String
    end

    it "#small" do
      subject.image_url(:small).should be_kind_of String
    end
  end

  it "default scope is ordered by position field" do
    subject.position = 1
    subject.save
    image = Fabricate.build(:image_800_600)
    image.position = 2
    subject.feature.value.push(image)

    node.features.first.value.should == [subject, image]
  end

end
