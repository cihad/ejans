require 'spec_helper'

describe Features::ImageFeature do
  let(:node_type) { Fabricate(:node_type) }
  let(:node) { Fabricate.build(:node) }
  let(:feature) { Fabricate.build(:feature) }
  let(:feature_configuration) { Fabricate.build(:feature_configuration) }
  let(:image_fc) { Fabricate.build(:image_fc) }

  before do
    feature_configuration.image_feature_configuration = image_fc
    node_type.feature_configurations << feature_configuration
    feature_configuration.save
    node.node_type = node_type
    feature.feature_configuration = feature_configuration
    node.features << feature
    image_feature = feature.image_feature = Fabricate.build(:image_feature)
  end

  subject do
    feature.image_feature
  end

  specify { subject.class.should respond_to(:add_value) }
  it { should respond_to :value }
  it { should respond_to feature_configuration.value_name.to_sym }
  it { should be_valid }

  context "should be exists has_and_belongs_to_many association by value_name" do 
    specify do
      subject.class.
        reflect_on_association(subject.configuration.value_name).
        should_not be_nil
    end

    specify do
      subject.class.
        reflect_on_association(subject.configuration.value_name).
        name.should == subject.configuration.value_name.to_sym
    end
  end

  specify do
    subject.feature.should == feature
  end

  # context "#validations" do
  #   context "when date is null" do
  #     before do
  #       subject.send("#{feature_configuration.value_name}=", Date.new(1))
  #     end

  #     specify do
  #       subject.should_not be_valid
  #     end
  #   end

  #   context "when date is lower than conf's start date" do
  #     before do
  #       subject.send("#{feature_configuration.value_name}=",
  #                   Date.new(date_fc.start_year).prev_day)
  #     end

  #     specify { subject.should_not be_valid }
  #   end

  #   context "when date is greater than conf's end date" do
  #     before do
  #       subject.send("#{feature_configuration.value_name}=",
  #                   Date.new(date_fc.end_year).end_of_year.next_day)
  #     end

  #     specify { subject.should_not be_valid }
  #   end
  # end
end
