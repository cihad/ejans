require 'spec_helper'

describe Node do
  let(:node_type) { Fabricate(:node_type) }
  let(:node) { Fabricate.build(:node, node_type: node_type) }
  let(:user) { Fabricate(:user) }
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

  context "state" do
    it "is new after create" do
      subject.should be_new
    end

    it "is pending approval after submit" do
      subject.submit!
      subject.should be_pending_approval
    end

    it "is published after accept" do
      subject.submit!
      subject.accept!
      subject.should be_published
    end

    it "is rejected after reject" do
      subject.submit!
      subject.reject!
      subject.should be_rejected
    end

    it "is expired after expire" do
      subject.submit!
      subject.accept!
      subject.expire!
      subject.should be_expired
    end
  end
end