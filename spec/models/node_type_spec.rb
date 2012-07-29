require 'spec_helper'

describe NodeType do

  let(:node_type) { Fabricate.build(:node_type) }
  subject { node_type }
  it { should respond_to :name }
  it { should respond_to :title_label }
  it { should respond_to :description }
  it { should be_valid }

  it "when name is not present" do
    node_type.name = ""
    node_type.should_not be_valid
  end

  it "should has not a view" do
    node_type.views.should be_blank
  end

  it "when node_type is saved should created a node view" do
    node_type.save
    node_type.views.should_not be_blank
  end


  describe "Emlak Service" do
    let(:emlak) { Fabricate.build(:emlak) }
    subject { emlak }

    before do
      emlak.save
      emlak.feature_configurations.each {|fc| fc.save }
    end

    it { should_not be_nil }

    it "has 7 feature_configurations" do
      emlak.feature_configurations.size.should == 7
    end

    it "when emlak is deleted, feature_configurations should be deleted" do 
      fcs = emlak.feature_configurations
      emlak.destroy
      fcs.each do |fc|
        Features::FeatureConfiguration.where(id: fc.id).first.should be_nil
      end
    end

    it "has 0 filter" do
      emlak.filters.size.should == 0
    end
  end
end