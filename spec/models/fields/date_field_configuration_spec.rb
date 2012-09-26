require 'spec_helper'

describe Fields::DateFieldConfiguration do

  let(:node_type) { Fabricate(:node_type) }
  let(:conf) { Fabricate.build(:date_fc) }

  before do
    conf.node_type = node_type
  end

  subject { conf }

  it { should respond_to :date_type }
  it { should respond_to :filter_type }
  it { should respond_to :start_date_type }
  it { should respond_to :x_years_ago_start }
  it { should respond_to :spesific_start_date }
  it { should respond_to :end_date_type }
  it { should respond_to :x_years_ago_end }
  it { should respond_to :x_years_later_end }
  it { should respond_to :spesific_end_date }
  it { should respond_to :filter_query }
  it { should be_new_record }
  it { should be_valid }

  context "#configuration class" do
    specify { subject.class.should respond_to(:non_fields_for_date_types) }
    specify { subject.class.should respond_to(:internal_object) }
    specify { subject.class.should respond_to(:default_value) }
    specify { subject.class.superclass.should == Fields::FieldConfiguration }
  end

  context "#field_class" do
    specify { subject.field_class.should == Fields::DateField }
  end

  context "#partial_dir" do
    specify { subject.partial_dir.should == "fields/date" }
  end

  context "#humanize_field_name" do
    specify { subject.humanize_field_name.should == "Date" }
  end

  context "#now_year method" do
    specify { subject.now_year.should == Time.now.to_date.year }
  end

  context "#to_year" do
    specify { subject.to_year(10).should == (Time.now.to_date.year - 10) }
    specify { subject.to_year(-10).should == (Time.now.to_date.year + 10) }
  end

  context "#start_date_type" do
    context "when :start_now" do
      before do
        subject.start_date_type = :start_now
        subject.save
      end

      specify { subject.start_year.should == Time.now.to_date.year  }

      [:x_years_ago_start, :spesific_start_date].each do |type|
        specify do
          subject.send(type).should ==  subject.class.default_value(type)
        end
      end
    end

    context "when :x_years_ago_start" do
      before do
        subject.start_date_type = :x_years_ago_start
        subject.save
      end

      specify { subject.start_year.should == (Time.now.to_date.year - subject.x_years_ago_start) }

      specify do
        subject.spesific_start_date.should == subject.class.default_value(:spesific_start_date)
      end
    end

    context "when :spesific_start_date" do
      before do
        subject.start_date_type = :spesific_start_date
        subject.save
      end

      specify { subject.start_year.should == subject.spesific_start_date.year }

      specify do
        subject.x_years_ago_start.should == subject.class.default_value(:x_years_ago_start)
      end
    end
  end

  context "#end_date_type" do
    context "when :end_now" do
      before do
        subject.end_date_type = :end_now
        subject.save
      end

      specify { subject.end_year.should == Time.now.to_date.year  }

      [:x_years_ago_end, :x_years_later_end, :spesific_end_date].each do |type|
        specify do
          subject.send(type).should == subject.class.default_value(type)
        end
      end
    end

    context "when :x_years_ago_end" do
      before do
        subject.end_date_type = :x_years_ago_end
        subject.save
      end

      specify { subject.end_year.should == subject.x_years_ago_end.years.ago.to_date.year  }

      [:x_years_later_end, :spesific_end_date].each do |type|
        specify do
          subject.send(type).should == subject.class.default_value(type)
        end
      end
    end

    context "when :x_years_later_end" do
      before do
        subject.end_date_type = :x_years_later_end
        subject.save
      end

      specify { subject.end_year.should == (-subject.x_years_later_end).years.ago.to_date.year  }

      [:x_years_ago_end, :spesific_end_date].each do |type|
        specify do
          subject.send(type).should == subject.class.default_value(type)
        end
      end
    end

    context "when :spesific_end_date" do
      before do
        subject.end_date_type = :spesific_end_date
        subject.save
      end

      specify { subject.end_year.should == subject.spesific_end_date.year }

      [:x_years_later_end, :x_years_ago_end].each do |type|
        specify do
          subject.send(type).should == subject.class.default_value(type)
        end
      end
    end
  end

  context "#filter_query" do
    before do
      subject.label = "Label for Field"
    end

    context "when filter_type is :single" do
      before do
        subject.filter_type = :single
        subject.save
      end
      
      context "when params is blank" do
        let(:params) { {} }
        specify { subject.filter_query(params).should == NodeQuery.new }
      end

      context "when params is filled" do
        let(:params) { {"#{subject.machine_name}" => 2010} }
        specify do
          subject.filter_query(params).should ==
            NodeQuery.new.
              between(:"fields.#{subject.keyname}" =>
                        Date.new.change(year: 2010)..Date.new.change(year: 2010).end_of_year)
        end
      end
    end

    context "when filter_type is :range" do
      before do
        subject.filter_type = :range
        subject.save
      end

      context "when params is blank" do
        let(:params) { {} }
        specify { subject.filter_query(params).should == NodeQuery.new }
      end

      context "when params is only filled by start value" do 
        context "when start value is lower than conf's start year" do
          let(:params) { {  "#{subject.machine_name}_start" => "#{subject.start_year - 1}"} }
          specify { subject.filter_query(params).should == NodeQuery.new }
        end

        context "when start value is greater than conf's start year" do
          let(:params) { {"#{subject.machine_name}_start" => "#{subject.start_year + 1}"} }
          specify { subject.filter_query(params).should ==
            NodeQuery.new.gte(:"fields.#{subject.keyname}" => Date.new(subject.start_year + 1))
          }
        end
      end

      context "when params is only filled by end value" do 
        context "when end value is greater than conf's end_year value" do
          let(:params) { {"#{subject.machine_name}_end" => "#{subject.end_year + 1}"} }
          specify { subject.filter_query(params).should == NodeQuery.new }
        end

        context "when end value is lower than conf's end_year value" do
          let(:params) { {"#{subject.machine_name}_end" => "#{subject.end_year - 1}"} }
          specify { subject.filter_query(params).should ==
            NodeQuery.new.lte(:"fields.#{subject.keyname}" => Date.new(subject.end_year - 1).end_of_year)
          }
        end
      end

      context "when params is filled" do
        let(:params) do
          {
            "#{subject.machine_name}_start" => "#{subject.start_year - 1}",
            "#{subject.machine_name}_end" => "#{subject.end_year + 1}"
          }
        end
        specify { subject.filter_query(params).should == NodeQuery.new }
      end
    end
  end

  context "#sort_query" do
    before do
      subject.sort = true
      subject.save
    end

    context "when params is blank" do
      let(:params) { {} }
      specify { subject.sort_query(params).should == NodeQuery.new }
    end

    context "when params filled by foreign keys" do
      let(:params) { {:sort => "this-is-foreign-key", :direction => "asc"} }
      specify { 
        subject.sort_query(params).should == NodeQuery.new
      }
    end

    context "when params filled by own machine name" do
      let(:params) { {:sort => "#{subject.machine_name}", :direction => "asc"} }
      specify {
        subject.sort_query(params).should == NodeQuery.new.order_by(:"fields.#{subject.keyname}" => :asc)
      }
    end

    context "when params filled by own machine name" do
      let(:params) { {:sort => "#{subject.machine_name}", :direction => "desc"} }
      specify {
        subject.sort_query(params).should == NodeQuery.new.order_by(:"fields.#{subject.keyname}" => :desc)
      }
    end
  end
end