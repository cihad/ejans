require 'spec_helper'

describe Features::IntegerFeature do
  let(:node_type) { Fabricate(:node_type) }
  let(:node) { Fabricate.build(:node) }
  let(:conf) { Fabricate.build(:integer_fc) }

  before do
    node_type.feature_configurations << conf
    conf.save
    node.node_type = node_type
    node.save
    feature = node.features.first
    feature.send("#{conf.key_name}=", 1000)
  end

  subject do
    node.features.first
  end

  specify do
    subject.class.should respond_to :set_specify
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
      fields[conf.key_name.to_s].options[:type].should == Integer
    end

    specify do
      fields[conf.key_name.to_s].name.should == conf.key_name.to_s
    end
  end

  context "#min" do
    specify { subject.min.should == conf.minimum }
  end

  context "#max" do
    specify { subject.max.should == conf.maximum }
  end

  context "#validations" do
    context "when integer field is null" do
      before do
        subject.send("#{conf.key_name}=", nil)
      end

      specify { subject.should_not be_valid }
    end

    context "when integer field is lower than conf's minimum value" do
      before do
        subject.send("#{conf.key_name}=",
                    conf.minimum - 1)
      end

      specify { subject.should_not be_valid }
    end

    context "when integer field is greater than conf's maximum value" do
      before do
        subject.send("#{conf.key_name}=",
                    conf.maximum + 1)
      end

      specify { subject.should_not be_valid }
    end

    context "when feature filled by fill_random!" do 
      before do
        subject.fill_random!
      end

      specify { subject.should be_valid }
    end
  end
end