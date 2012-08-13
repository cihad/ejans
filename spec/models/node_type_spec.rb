require 'spec_helper'

describe NodeType do

  let(:node_type) { Fabricate(:node_type) }
  let(:integer_fc) { Fabricate.build(:integer_fc) }
  let(:string_fc) { Fabricate.build(:string_fc) }
  let(:node) { Fabricate.build(:node) }

  before do
    integer_fc.node_type = node_type
    string_fc.node_type = node_type
    integer_fc.save
    string_fc.save
    node.node_type = node_type
    node.fill_random!
    node.save
  end

  subject { node_type }

  it { should respond_to :name }
  it { should respond_to :title_label }
  it { should respond_to :description }
  it { should respond_to :filters_position }
  it { should be_valid }

  it "when name is not present" do
    node_type.name = ""
    node_type.should_not be_valid
  end

  context "#views" do
    it "node type when before save should has not a view" do
      subject.views.should_not be_blank
    end

    it "node type when destroy should be destroyed views" do
      views_ids = subject.views.map(&:id)
      subject.destroy
      views_ids.each do |id|
        Views::View.where(id: id).should_not be_exists
      end
    end
  end

  context "#nodes" do
    it "node type should have 1 node" do
      node_type.nodes.should_not be_blank
      node_type.nodes.size.should == 1
    end
  end

  context "#validations" do
    specify do
      subject.filters_position = :this_is_a_unvalid_option
      subject.should_not be_valid
    end
  end
end