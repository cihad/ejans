require 'spec_helper'

describe Place do
  
  let(:root_place) { Fabricate(:world) }
  let(:place) { root_place.children.first }
  let(:descendant_place) { place.children.first }
  let(:lng) { 38.963745 }
  let(:lat) { 35.243322 }

  subject { place }
  # - Top level place            LEVEL 0
  #   - child place 1              LEVEL 1 (<<-----SUBJECT-----<<<<<<<)
  #     - descendant place 1a        LEVEL 2
  #     - descendant place 1b        LEVEL 2
  #   - child place 2              LEVEL 1
  #     - descendant place 2a        LEVEL 2
  #     - descendant place 2b        LEVEL 2

  it { should respond_to :lng_lat }
  it { should respond_to :name }
  it { should be_valid }

  it "#name validation" do
    subject.name = ""
    subject.should_not be_valid
  end

  it "#lat_lng" do
    subject.lng_lat = [lng, lat]
    subject.lat_lng.should == [lat, lng]
  end

  it ".world" do
    subject.class.world.should == subject.class.root
  end

  it "#level" do
    subject.level.should == 1
    root_place.level.should == 0
    subject.level.should == 1
    descendant_place.level.should == 2
  end

  it "#childs=" do
    subject.childs = %q{
      A Sample Place
      Other Sample Place
    }

    subject.save

    ["A Sample Place", "Other Sample Place"].each do |place_name|
      subject.children.map(&:name).should be_include place_name
    end
  end

  it "#parent" do
    subject.parent.should == root_place
  end

  it "#children" do
    subject.children.should be_include descendant_place
  end

  it "#hierarchical_name" do
    subject.hierarchical_name.should == "#{root_place.name} > #{subject.name}"
  end

end