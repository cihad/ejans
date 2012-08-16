require 'spec_helper'

describe Features::ImageFeature do
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
    feature.send(conf.key_name).push(image)
  end

  subject do
    node.features.first
  end

  it { should respond_to :value }
  it { should respond_to conf.key_name }
  it { should be_valid }

  context "should be exists embeds_many association by key_name" do 
    specify do
      subject.class.
        reflect_on_association(conf.key_name).
        should_not be_nil
    end

    specify do
      subject.class.
        reflect_on_association(conf.key_name).
        macro.should == :embeds_many
    end
  end

  context "#validations" do
    context "when image is null" do
      before do
        image.destroy
      end

      specify do
        subject.should_not be_valid
      end
    end

    context "when image size is greater than maximum image" do
      before do
        subject.conf.maximum_image = 1
        subject.send(conf.key_name).push(Fabricate.build(:image_800_600))
      end

      specify do
        subject.should_not be_valid
      end
    end

    context "when feature filled by fill_random!" do 
      before do
        subject.fill_random!
      end

      specify { subject.should be_valid }
    end
  end

end
