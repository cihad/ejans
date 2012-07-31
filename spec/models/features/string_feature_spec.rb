require 'spec_helper'

describe Features::StringFeature do
  let(:node_type) { Fabricate(:node_type) }
  let(:node) { Fabricate.build(:node) }
  let(:conf) { Fabricate.build(:string_fc) }

  before do
    node_type.feature_configurations << conf
    conf.save
    node.node_type = node_type
    node.save
    feature = node.features.first
    feature.send("#{conf.key_name}=", "Sample text for feature")
  end

  subject do
    node.features.first
  end

  specify do
    subject.class.should respond_to :set_key
  end
  
  it { should respond_to :value }
  it { should respond_to conf.key_name }
  it { should be_valid }

  context "should be exists field by key_name" do 
    let(:fields) { subject.class.fields }
    specify do
      fields[conf.key_name.to_s].should_not be_nil
    end

    specify do
      fields[conf.key_name.to_s].options[:type].should == String
    end

    specify do
      fields[conf.key_name.to_s].name.should == conf.key_name.to_s
    end
  end

  context "#validations" do
    context "when string field is null" do
      before do
        subject.send("#{conf.key_name}=", nil)
      end

      specify { subject.should_not be_valid }
    end

    context "when string field is lower than conf's minimum value" do
      before do
        conf.minimum_length = 100
        conf.save
        subject.send("#{conf.key_name}=",
                    "a" * (subject.min - 1))
      end

      specify { subject.should_not be_valid }
    end

    context "when string field is greater than conf's maximum value" do
      before do
        conf.maximum_length = 100
        conf.save
        subject.send("#{conf.key_name}=",
                    "a" * (subject.max + 1))
      end

      specify { subject.should_not be_valid }
    end
  end
end