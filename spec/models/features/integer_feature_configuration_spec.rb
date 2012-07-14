require 'spec_helper'

describe Features::IntegerFeatureConfiguration do
  let(:node_type) { Fabricate(:node_type) }
  let(:fc) { Fabricate.build(:feature_configuration) }

  before do
    fc.node_type = node_type
    fc.integer_feature_configuration = Fabricate.build(:integer_fc)
  end

  subject { fc.integer_feature_configuration }

  it { should respond_to :filter_type }
  it { should respond_to :minumum }
  it { should respond_to :maximum }
  it { should respond_to :prefix }
  it { should respond_to :suffix }
  it { should respond_to :thousand_marker }
  it { should respond_to :build_assoc! }
  it { should respond_to :filter_query }
  it { should be_new_record }
  it { should be_valid }

  specify do
    subject.parent.should == fc
  end

  specify do
    subject.type.should == "Integer"
  end

  specify do
    subject.should be_filterable
  end

  context "#feature_configuration" do
    subject { fc }

    before do
      subject.label = "Label for Integer Feature"
    end

    specify do
      subject.machine_name.should == "label_for_integer_feature"
    end

    context "when save" do
      before do
        subject.save
      end

      specify do
        subject.value_name.should == "integer_feature_value_0"
      end

      context "when multiple integer feature" do
        before do
          @other_conf = Fabricate.build(:feature_configuration)
          @other_conf.integer_feature_configuration = Fabricate.build(:integer_fc)
          @other_conf.node_type = node_type
          @other_conf.save
        end

        specify do
          @other_conf.value_name.should_not == subject.value_name
        end

        specify do
          @other_conf.value_name.should == "integer_feature_value_1"
        end
      end
    end
  end

  context "#filter_query" do
    before do
      fc.label = "Label for Feature"
    end

    context "when filter_type is number_field" do
      before do
        subject.filter_type = :number_field
        fc.save
      end
      
      context "when params is blank" do
        let(:params) { {} }
        specify { subject.filter_query(params).should == {} }
      end

      context "when params is filled" do
        let(:params) { {"#{subject.machine_name}" => "10"} }
        specify { subject.filter_query(params).should ==
          {"features.integer_feature.#{subject.value_name}"=>10} }
      end
    end

    context "when filter_type is :range_with_number_field" do
      before do
        subject.filter_type = :range_with_number_field
        fc.save
      end

      context "when params is blank" do
        let(:params) { {} }
        specify { subject.filter_query(params).should == {} }
      end

      context "when params is only filled by min value" do 
        context "when min value is lower than conf's minimum value" do
          let(:params) { {"#{subject.machine_name}_min" => "#{subject.minumum - 1}"} }
          specify { subject.filter_query(params).should == {} }
        end

        context "when min value is greater than conf's minimum value" do
          let(:params) { {"#{subject.machine_name}_min" => "#{subject.minumum + 1}"} }
          specify { subject.filter_query(params).should ==
            {"features.integer_feature.#{fc.value_name}"=>{"$gte"=> (subject.minumum + 1)}} }
        end
      end

      context "when params is only filled by max value" do 
        context "when max value is greater than conf's maximum value" do
          let(:params) { {"#{subject.machine_name}_max" => "#{subject.maximum + 1}"} }
          specify { subject.filter_query(params).should == {} }
        end

        context "when max value is lower than conf's maximum value" do
          let(:params) { {"#{subject.machine_name}_max" => "#{subject.maximum - 1}"} }
          specify { subject.filter_query(params).should ==
            {"features.integer_feature.#{fc.value_name}"=>{"$lte"=> (subject.maximum - 1)}} }
        end
      end

      context "when params is filled" do
        let(:params) do
          {
            "#{subject.machine_name}_min" => "#{subject.minumum - 1}",
            "#{subject.machine_name}_max" => "#{subject.maximum + 1}"
          }
        end

        specify { subject.filter_query(params).should == {} }
      end
    end
  end

  context "when fc's filter is true" do
    before do
      fc.filter = true
      fc.save
    end

    specify { node_type.filters.should include(fc) }
  end
end