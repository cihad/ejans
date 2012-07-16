require 'spec_helper'

describe Features::DateFeatureConfiguration do

  let(:node_type) { Fabricate(:node_type) }
  let(:fc) { Fabricate.build(:feature_configuration) }
  let(:date_class) { Features::DateFeatureConfiguration }

  before do
    fc.node_type = node_type
    fc.date_feature_configuration = Fabricate.build(:date_fc)
  end

  subject { fc.date_feature_configuration }

  it { should respond_to :date_type }
  it { should respond_to :filter_type }
  it { should respond_to :start_date_type }
  it { should respond_to :x_years_ago_start }
  it { should respond_to :spesific_start_date }
  it { should respond_to :end_date_type }
  it { should respond_to :x_years_ago_end }
  it { should respond_to :x_years_later_end }
  it { should respond_to :spesific_end_date }
  it { should respond_to :build_assoc! }
  it { should respond_to :filter_query }
  it { should be_new_record }
  it { should be_valid }

  specify do
    subject.parent.should == fc
  end

  specify do
    subject.type.should == "Date"
  end

  specify do
    subject.should be_filterable
  end

  context "#date_feature_configuration class" do
    specify { subject.class.should respond_to(:non_fields_for_date_types) }
    specify { subject.class.should respond_to(:internal_object) }
    specify { subject.class.should respond_to(:default_value) }

    specify do
      subject.class.non_fields_for_date_types.should be_kind_of(Hash)
    end
  end

  context "#feature_configuration" do
    subject { fc }

    before do
      subject.label = "Label for Date Feature"
    end

    specify do
      subject.machine_name.should == "label_for_date_feature"
    end

    context "when save" do
      before do
        subject.save
      end

      specify do
        subject.value_name.should == "date_feature_value_0"
      end

      context "when multiple date feature" do
        before do
          @other_conf = Fabricate.build(:feature_configuration)
          @other_conf.date_feature_configuration = Fabricate.build(:date_fc)
          @other_conf.node_type = node_type
          @other_conf.save
        end

        specify do
          @other_conf.value_name.should_not == subject.value_name
        end

        specify do
          @other_conf.value_name.should == "date_feature_value_1"
        end
      end
    end
  end

  context "#now_year method" do
    specify { subject.now_year.should == Time.now.to_date.year }
  end

  context "#to_year" do
    before do
      now_year = 2012
    end

    specify { subject.to_year(10).should == 2002 }
    specify { subject.to_year(-10).should == 2022 }
  end

  context "#start_date_type" do
    context "when :start_now" do
      before do
        subject.start_date_type = :start_now
        fc.save
      end

      specify { subject.start_year.should == Time.now.to_date.year  }

      [:x_years_ago_start, :spesific_start_date].each do |type|
        specify do
          subject.send(type).should ==  date_class.default_value(type)
        end
      end
    end

    context "when :x_years_ago_start" do
      before do
        subject.start_date_type = :x_years_ago_start
        fc.save
      end

      specify { subject.start_year.should == (Time.now.to_date.year - subject.x_years_ago_start) }

      specify do
        subject.spesific_start_date.should == date_class.default_value(:spesific_start_date)
      end
    end

    context "when :spesific_start_date" do
      before do
        subject.start_date_type = :spesific_start_date
        fc.save
      end

      specify { subject.start_year.should == subject.spesific_start_date.year }

      specify do
        subject.x_years_ago_start.should == date_class.default_value(:x_years_ago_start)
      end
    end
  end

  context "#end_date_type" do
    context "when :end_now" do
      before do
        subject.end_date_type = :end_now
        fc.save
      end

      specify { subject.end_year.should == Time.now.to_date.year  }

      [:x_years_ago_end, :x_years_later_end, :spesific_end_date].each do |type|
        specify do
          subject.send(type).should == date_class.default_value(type)
        end
      end
    end

    context "when :x_years_ago_end" do
      before do
        subject.end_date_type = :x_years_ago_end
        fc.save
      end

      specify { subject.end_year.should == subject.x_years_ago_end.years.ago.to_date.year  }

      [:x_years_later_end, :spesific_end_date].each do |type|
        specify do
          subject.send(type).should == date_class.default_value(type)
        end
      end
    end

    context "when :x_years_later_end" do
      before do
        subject.end_date_type = :x_years_later_end
        fc.save
      end

      specify { subject.end_year.should == (-subject.x_years_later_end).years.ago.to_date.year  }

      [:x_years_ago_end, :spesific_end_date].each do |type|
        specify do
          subject.send(type).should == date_class.default_value(type)
        end
      end
    end

    context "when :spesific_end_date" do
      before do
        subject.end_date_type = :spesific_end_date
        fc.save
      end

      specify { subject.end_year.should == subject.spesific_end_date.year }

      [:x_years_later_end, :x_years_ago_end].each do |type|
        specify do
          subject.send(type).should == date_class.default_value(type)
        end
      end
    end
  end

  context "#filter_query" do
    before do
      fc.label = "Label for Feature"
    end

    context "when filter_type is :single" do
      before do
        subject.filter_type = :single
        fc.save
      end
      
      context "when params is blank" do
        let(:params) { {} }
        specify { subject.filter_query(params).should == {} }
      end

      context "when params is filled" do
        let(:params) { {"#{subject.machine_name}" => 2010} }
        specify do
          subject.filter_query(params).should ==
            NodeQuery.new.
              between(:"features.date_feature.#{subject.value_name}" =>
                        Date.new.change(year: 2010)..Date.new.change(year: 2010).end_of_year).
              selector
        end
      end
    end

    context "when filter_type is :range" do
      before do
        subject.filter_type = :range
        fc.save
      end

      context "when params is blank" do
        let(:params) { {} }
        specify { subject.filter_query(params).should == {} }
      end

      context "when params is only filled by start value" do 
        context "when start value is lower than conf's start year" do
          let(:params) { {"#{subject.machine_name}_start" => "#{subject.start_year - 1}"} }
          specify { subject.filter_query(params).should == {} }
        end

        context "when start value is greater than conf's start year" do
          let(:params) { {"#{subject.machine_name}_start" => "#{subject.start_year + 1}"} }
          specify { subject.filter_query(params).should ==
            {"features.date_feature.#{fc.value_name}"=>{"$gte"=> (subject.start_year + 1)}} }
        end
      end

      context "when params is only filled by end value" do 
        context "when end value is greater than conf's end_year value" do
          let(:params) { {"#{subject.machine_name}_end" => "#{subject.end_year + 1}"} }
          specify { subject.filter_query(params).should == {} }
        end

        context "when end value is lower than conf's end_year value" do
          let(:params) { {"#{subject.machine_name}_end" => "#{subject.end_year - 1}"} }
          specify { subject.filter_query(params).should ==
            {"features.date_feature.#{fc.value_name}"=>{"$lte"=> (subject.end_year - 1)}} }
        end
      end

      context "when params is filled" do
        let(:params) do
          {
            "#{subject.machine_name}_start" => "#{subject.start_year - 1}",
            "#{subject.machine_name}_end" => "#{subject.end_year + 1}"
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