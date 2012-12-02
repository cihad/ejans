require 'spec_helper'

describe Node do
  let(:node_type) { Fabricate(:node_type) }
  let(:node) { Fabricate.build(:node) }
  let(:user) { Fabricate(:user) }

  before do
    node.node_type = node_type
  end

  subject { node }

  it { should be_respond_to :title }
  it { should be_respond_to :created_at }
  it { should be_respond_to :updated_at }
  it { should be_valid }

  context "validations" do
    specify do
      subject.title = ""
      subject.should_not be_valid
    end
  end

  context "#fill_with_random_values" do
    let(:node_type) { Fabricate(:full_featured_node_type) }
    let(:node) { NewNode.new(node_type, user).node }

    specify do
      node.should_not be_valid
    end

    specify do
      node.title = valid_attributes_for(:node)["title"]
      node.fill_with_random_values
      node.should be_valid
    end
  end
end