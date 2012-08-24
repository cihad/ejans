require 'spec_helper'

describe Features::IntegerFeatureConfiguration do

  let(:node_type) { Fabricate(:node_type) }
  let(:conf) { Fabricate.build(:integer_fc) }
  let(:blank_query) { NodeQuery.new }

  before do
    conf.node_type = node_type
  end

  subject { conf }

  it { should respond_to :filter_type }
  it { should respond_to :minimum }
  it { should respond_to :maximum }
  it { should respond_to :prefix }
  it { should respond_to :suffix }
  it { should respond_to :thousand_marker }
  it { should respond_to :build_assoc! }
  it { should respond_to :filter_query }
  it { should be_new_record }
  it { should be_valid }

  context "#configuration class" do
    specify { subject.class.superclass.should == Features::FeatureConfiguration }
  end

  context "#feature_class" do
    specify { subject.feature_class.should == Features::IntegerFeature }
  end

  context "#partial_dir" do
    specify { subject.partial_dir.should == "features/integer" }
  end

  context "#humanize_feature_name" do
    specify { subject.humanize_feature_name.should == "Integer" }
  end

  context "#filter_query" do
    before do
      conf.label = "Label for Feature"
    end

    context "when filter_type is number_field" do
      before do
        subject.filter_type = :number_field
        conf.save
      end
      
      context "when params is blank" do
        let(:params) { {} }
        specify { subject.filter_query(params).should == blank_query }
      end

      context "when params is filled" do
        let(:params) { {"#{subject.machine_name}" => "10"} }
        specify {
          subject.filter_query(params).should ==
            blank_query.where(:"features.#{subject.key_name}" => 10)
        }
      end
    end

    context "when filter_type is :range_with_number_field" do
      before do
        subject.filter_type = :range_with_number_field
        conf.save
      end

      context "when params is blank" do
        let(:params) { {} }
        specify { subject.filter_query(params).should == blank_query }
      end

      context "when params is only filled by min value" do 
        context "when min value is lower than conf's minimum value" do
          let(:params) { {"#{subject.machine_name}_min" => "#{subject.minimum - 1}"} }
          specify { subject.filter_query(params).should == blank_query }
        end

        context "when min value is greater than conf's minimum value" do
          let(:params) { {"#{subject.machine_name}_min" => "#{subject.minimum + 1}"} }
          specify {
            subject.filter_query(params).should ==
              blank_query.gte(:"features.#{conf.key_name}" => (subject.minimum + 1))
          }
        end
      end

      context "when params is only filled by max value" do 
        context "when max value is greater than conf's maximum value" do
          let(:params) { {"#{subject.machine_name}_max" => "#{subject.maximum + 1}"} }
          specify { subject.filter_query(params).should == blank_query }
        end

        context "when max value is lower than conf's maximum value" do
          let(:params) { {"#{subject.machine_name}_max" => "#{subject.maximum - 1}"} }
          specify {
            subject.filter_query(params).should ==
              blank_query.lte(:"features.#{conf.key_name}" => (subject.maximum - 1))
          }
        end
      end

      context "when params is filled" do
        let(:params) do
          {
            "#{subject.machine_name}_min" => "#{subject.minimum - 1}",
            "#{subject.machine_name}_max" => "#{subject.maximum + 1}"
          }
        end

        specify { subject.filter_query(params).should == blank_query }
      end
    end
  end
end