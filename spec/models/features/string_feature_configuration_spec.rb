require 'spec_helper'

describe Features::StringFeatureConfiguration do

  let(:node_type) { Fabricate(:node_type) }
  let(:fc) { Fabricate.build(:feature_configuration) }

  before do
    fc.node_type = node_type
    fc.string_feature_configuration = Fabricate.build(:string_fc)
  end

  subject { fc.string_feature_configuration }

  it { should respond_to :row }
  it { should respond_to :minumum_length }
  it { should respond_to :maximum_length }
  it { should respond_to :text_format }
  it { should respond_to :build_assoc! }
  it { should be_new_record }
  it { should be_valid }

  specify do
    subject.parent.should == fc
  end

  specify do
    subject.type.should == "String"
  end

  specify do
    subject.should_not be_filterable
  end

  context "text_formal is invalid attribute" do
    before do
      subject.text_format = :invalid_attribute
    end

    it { should_not be_valid }
  end

  context "#feature_configuration" do
    subject { fc }

    before do
      subject.label = "Label for String Feature"
    end

    specify do
      subject.machine_name.should == "label_for_string_feature"
    end

    context "when save" do
      before do
        subject.save
      end

      specify do
        subject.value_name.should == "string_feature_value_0"
      end

      context "when multiple string feature" do
        before do
          @other_conf = Fabricate.build(:feature_configuration)
          @other_conf.string_feature_configuration = Fabricate.build(:string_fc)
          @other_conf.node_type = node_type
          @other_conf.save
        end

        specify do
          @other_conf.value_name.should_not == subject.value_name
        end

        specify do
          @other_conf.value_name.should == "string_feature_value_1"
        end
      end
    end
  end
end
