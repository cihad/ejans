require 'spec_helper'

describe Features::DateFeature do
  let(:node_type) { Fabricate(:node_type) }
  let(:node) { Fabricate.build(:node) }
  let(:conf) { Fabricate.build(:date_fc) }

  before do
    node_type.feature_configurations << conf
    conf.save
    node.node_type = node_type
    node.save
    feature = node.features.first
    feature.send("#{conf.key_name}=", 11.years.ago.to_date)
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
      fields[conf.key_name.to_s].options[:type].should == Date
    end

    specify do
      fields[conf.key_name.to_s].name.should == conf.key_name.to_s
    end
  end

  context "#validations" do
    context "when date is null" do
      before do
        subject.send("#{conf.key_name}=", Date.new(1))
      end

      specify do
        subject.should_not be_valid
      end
    end

    context "when date is lower than conf's start date" do
      before do
        subject.send("#{conf.key_name}=",
                    Date.new(conf.start_year).prev_day)
      end

      specify { subject.should_not be_valid }
    end

    context "when date is greater than conf's end date" do
      before do
        subject.send("#{conf.key_name}=",
                    Date.new(conf.end_year).end_of_year.next_day)
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
