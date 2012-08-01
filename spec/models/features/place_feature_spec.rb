require 'spec_helper'

describe Features::PlaceFeature do
  let(:node_type) { Fabricate(:node_type) }
  let(:node) { Fabricate.build(:node) }
  let(:conf) { Fabricate.build(:place_fc) }
  let(:top_place) { Fabricate(:place) }
  let(:child_place_1) { Fabricate(:place) }
  let(:child_place_2) { Fabricate(:place) }
  let(:child_place_3) { Fabricate(:place) }
  let(:other_place) { Fabricate(:place) }

  before do
    node_type.feature_configurations << conf
    conf.top_place = top_place
    conf.save
    node.node_type = node_type
    node.save
    feature = node.features.first

    child_place_1.parent_place = top_place
    child_place_2.parent_place = child_place_1
    child_place_3.parent_place = child_place_2

    # for 2 level
    feature.send(conf.key_name).push([
      child_place_1,
      child_place_2
    ])
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

  context "#validations" do
    context "when place is null" do
      before do
        #TODO ?clear
        subject.send("#{conf.key_name}").clear
      end

      specify { subject.should_not be_valid }
    end

    context "when place is unvalid place" do
      before do
        subject.send("#{conf.key_name}").push([
          child_place_3
        ])
      end

      specify { subject.should_not be_valid }
    end

    context "when selected is other place" do
      before do
        subject.send("#{conf.key_name}").push([
          other_place
        ])
      end

      specify { subject.should_not be_valid }
    end

    # context "when feature filled by fill_random!" do 
    #   before do
    #     subject.fill_random!
    #   end

    #   specify { subject.should be_valid }
    # end
  end
end
