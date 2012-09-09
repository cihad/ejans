require 'spec_helper'

describe Features::PlaceFeatureConfiguration do
  let(:node_type) { Fabricate(:node_type) }
  let(:conf) { Fabricate.build(:place_fc) }
  let(:place) { Fabricate(:turkiye) }
  let(:blank_query) { NodeQuery.new }  

  before do
    conf.node_type = node_type
    conf.top_place = place
  end

  subject { conf }

  it { should respond_to :level }
  it { should respond_to :place_page_list }
  it { should respond_to :top_place }
  it { should respond_to :build_assoc! }
  it { should respond_to :filter_query }
  it { should be_new_record }
  it { should be_valid }

  context "#configuration class" do
    specify { subject.class.superclass.should == Features::FeatureConfiguration }
  end

  context "#feature_class" do
    specify { subject.feature_class.should == Features::PlaceFeature }
  end

  context "#partial_dir" do
    specify { subject.partial_dir.should == "features/place" }
  end

  context "#humanize_feature_name" do
    specify { subject.humanize_feature_name.should == "Place" }
  end

  context "#top_place association" do
    specify do
      subject.top_place.should_not be_nil
    end

    specify do
      subject.top_place.should be_kind_of(Place)
    end

    specify do
      subject.level_names.should == subject.top_place.bottom_level_names.first(subject.level + 1)
    end

    specify do
      subject.level_machine_names.should == subject.top_place.bottom_level_machine_names.first(subject.level + 1)
    end

    specify do
      names = subject.level_names
      names.shift
      names
      subject.form_level_names.should == names
    end

    specify do
      names = subject.level_machine_names
      names.shift
      subject.form_machine_names.should == names.map { |name| "#{subject.machine_name}_#{name}" }
    end
  end


  context "#filter_query" do
    before do
      subject.label = "Label for Place"
      subject.save
      subject.top_place.hierarchy = "ulke, sehir, ilce, mahalle"
      subject.top_place.save
      subject.level = 2
      subject.save
    end
    
    context "when params is blank" do
      let(:params) { {} }
      specify { subject.filter_query(params).should == blank_query }
    end

    context "when params is filled by first level" do
      let(:params) { {"label_for_place_sehir" => subject.top_place.children.first.id.to_s } }
      specify do
        subject.filter_query(params).should ==
          blank_query.in(:"features.place_value_0_ids" => 
            [subject.top_place.children.first.id])
      end
    end

    context "whem params is filled by level" do
      before do
        @place = Fabricate(:child_place)
        subject.top_place.children.first.children << @place
      end

      context "when params is filled by second level" do
        specify do  
          params = {
            "label_for_place_sehir" => subject.top_place.children.first.id.to_s,
            "label_for_place_ilce" => @place.id.to_s
          }

          subject.filter_query(params).should ==
            blank_query.in(:"features.place_value_0_ids" => [@place.id])
        end
      end

      context "when params is filled by outside level" do
        before do
          @other_place = Fabricate(:child_place)
          @place.children << @other_place
        end
        specify do  
          params = {
            "label_for_place_sehir" => subject.top_place.children.first.id.to_s,
            "label_for_place_ilce" => @place.id.to_s,
            "label_for_place_mahalle" => @other_place.id.to_s
          }

          subject.filter_query(params).should ==
            blank_query.in(:"features.place_value_0_ids" => [@place.id])
        end
      end

      context "when params is filled by 3rd level" do
        before do
          subject.level = 3
          subject.save
          @other_place = Fabricate(:child_place)
          @place.children << @other_place
        end
        specify do  
          params = {
            "label_for_place_sehir" => subject.top_place.children.first.id.to_s,
            "label_for_place_ilce" => @place.id.to_s,
            "label_for_place_mahalle" => @other_place.id.to_s
          }

          subject.filter_query(params).should ==
            blank_query.in(:"features.place_value_0_ids" => [@other_place.id])
        end
      end

    end
  end

  context "when conf's filter is true" do
    before do
      conf.filter = true
      conf.save
    end

    specify { node_type.filters.should include(conf) }
  end
end