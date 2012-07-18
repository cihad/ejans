require 'spec_helper'

describe Features::DateFeature do
  let(:node_type) { Fabricate(:node_type) }
  let(:node) { Fabricate.build(:node) }
  let(:feature) { Fabricate.build(:feature) }
  let(:feature_configuration) { Fabricate.build(:feature_configuration) }
  let(:date_fc) { Fabricate.build(:date_fc) }

  before do
    feature_configuration.date_feature_configuration = date_fc
    node_type.feature_configurations << feature_configuration
    feature_configuration.save
    node.node_type = node_type
    feature.feature_configuration = feature_configuration
    node.features << feature
    date_feature = feature.date_feature = Fabricate.build(:date_feature)
    date_feature.send("#{feature_configuration.value_name}=", 11.years.ago.to_date)
  end

  subject do
    feature.date_feature
  end

  it { should respond_to feature_configuration.value_name.to_sym }
  it { should be_valid }

  context "should be exists field by value_name" do 
    let(:fields) { subject.class.fields }
    specify do
      fields[feature_configuration.value_name].should_not be_nil
    end

    specify do
      fields[feature_configuration.value_name].options[:type].should == Date
    end

    specify do
      fields[feature_configuration.value_name].name.should == feature_configuration.value_name
    end
  end

  specify do
    subject.feature.should == feature
  end

  specify do
    subject.class.should respond_to :add_value
  end

  context "#validations" do
    context "when date is null" do
      before do
        subject.send("#{feature_configuration.value_name}=", Date.new(1))
      end

      specify do
        subject.should_not be_valid
      end
    end

    context "when date is lower than conf's start date" do
      before do
        subject.send("#{feature_configuration.value_name}=",
                    Date.new(date_fc.start_year).prev_day)
      end

      specify { subject.should_not be_valid }
    end

    context "when date is greater than conf's end date" do
      before do
        subject.send("#{feature_configuration.value_name}=",
                    Date.new(date_fc.end_year).end_of_year.next_day)
      end

      specify { subject.should_not be_valid }
    end
  end
end
