require 'spec_helper'

describe Features::PlaceFeatureConfiguration do
  let(:node_type) { Fabricate(:node_type) }
  let(:fc) { Fabricate.build(:feature_configuration) }

  before do
    fc.node_type = node_type
    fc.place_feature_configuration = Fabricate.build(:place_fc)
  end

  subject { fc.place_feature_configuration }

  it { should respond_to :level }
  it { should respond_to :top_place }
  it { should respond_to :build_assoc! }
  it { should respond_to :filter_query }
  it { should be_new_record }
  it { should be_valid }

  specify do
    subject.parent.should == fc
  end

  specify do
    subject.type.should == "Place"
  end

  specify do
    subject.should be_filterable
  end

  specify do
    subject.save
    subject.where.should == "features.place_feature.place_feature_value_0_ids"
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

  context "#feature_configuration" do
    subject { fc }

    before do
      subject.label = "Label for Place Feature"
    end

    specify do
      subject.machine_name.should == "label_for_place_feature"
    end

    context "when save" do
      before do
        subject.save
      end

      specify do
        subject.value_name.should == "place_feature_value_0"
      end

      context "when multiple place feature" do
        before do
          @other_conf = Fabricate.build(:feature_configuration)
          @other_conf.place_feature_configuration = Fabricate.build(:place_fc)
          @other_conf.node_type = node_type
          @other_conf.save
        end

        specify do
          @other_conf.value_name.should_not == subject.value_name
        end

        specify do
          @other_conf.value_name.should == "place_feature_value_1"
        end
      end
    end
  end
  
  context "#filter_query" do
    before do
      fc.label = "Label for Place"
      fc.save
      subject.top_place.hierarchy = "ulke, sehir, ilce, mahalle"
      subject.top_place.save
      subject.level = 2
      subject.save
    end
    
    context "when params is blank" do
      let(:params) { {} }
      specify { subject.filter_query(params).should == {} }
    end

    context "when params is filled by first level" do
      let(:params) { {"label_for_place_sehir" => subject.top_place.child_places.first.id.to_s } }
      specify do
        subject.filter_query(params).should ==
          NodeQuery.
            new.
            in(:"#{subject.where}" => 
                [subject.top_place.child_places.first.id]).
            selector
      end
    end

    context "whem params is filled by level" do
      before do
        @place = Fabricate(:child_place)
        subject.top_place.child_places.first.child_places << @place
      end

      context "when params is filled by second level" do
        specify do  
          params = {
            "label_for_place_sehir" => subject.top_place.child_places.first.id.to_s,
            "label_for_place_ilce" => @place.id.to_s
          }

          subject.filter_query(params).should ==
            NodeQuery.
              new.
              in(:"#{subject.where}" => 
                  [@place.id]).
              selector
        end
      end

      context "when params is filled by outside level" do
        before do
          @other_place = Fabricate(:child_place)
          @place.child_places << @other_place
        end
        specify do  
          params = {
            "label_for_place_sehir" => subject.top_place.child_places.first.id.to_s,
            "label_for_place_ilce" => @place.id.to_s,
            "label_for_place_mahalle" => @other_place.id.to_s
          }

          subject.filter_query(params).should ==
            NodeQuery.
              new.
              in(:"#{subject.where}" => 
                  [@place.id]).
              selector
        end
      end

      context "when params is filled by 3rd level" do
        before do
          subject.level = 3
          subject.save
          @other_place = Fabricate(:child_place)
          @place.child_places << @other_place
        end
        specify do  
          params = {
            "label_for_place_sehir" => subject.top_place.child_places.first.id.to_s,
            "label_for_place_ilce" => @place.id.to_s,
            "label_for_place_mahalle" => @other_place.id.to_s
          }

          subject.filter_query(params).should ==
            NodeQuery.
              new.
              in(:"#{subject.where}" => 
                  [@other_place.id]).
              selector
        end
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