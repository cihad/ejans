require 'spec_helper'

describe Features::ImageFeatureConfiguration do
  let(:node_type) { Fabricate(:node_type) }
  let(:fc) { Fabricate.build(:feature_configuration) }

  before do
    fc.node_type = node_type
    fc.image_feature_configuration = Fabricate.build(:image_fc)
  end

  subject { fc.image_feature_configuration }

  it { should respond_to :maximum_image }
  it { should respond_to :build_assoc! }
  it { should be_new_record }
  it { should be_valid }

  specify do
    subject.parent.should == fc
  end

  specify do
    subject.type.should == "Image"
  end

  specify do
    subject.should_not be_filterable
  end

  context "#feature_configuration" do
    subject { fc }

    before do
      subject.label = "Label for Image Feature"
    end

    specify do
      subject.machine_name.should == "label_for_image_feature"
    end

    context "when save" do
      before do
        subject.save
      end

      specify do
        subject.value_name.should == "zero_images"
      end

      context "when multiple image feature" do
        before do
          @other_conf = Fabricate.build(:feature_configuration)
          @other_conf.image_feature_configuration = Fabricate.build(:image_fc)
          @other_conf.node_type = node_type
          @other_conf.save
        end

        specify do
          @other_conf.value_name.should_not == subject.value_name
        end

        specify do
          @other_conf.value_name.should == "one_images"
        end
      end
    end
  end
end