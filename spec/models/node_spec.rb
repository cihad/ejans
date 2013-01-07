require 'spec_helper'

describe Node do

  let(:node_type) { Fabricate(:node_type) }
  let(:node) { Fabricate.build(:node, node_type: node_type) }
  let(:user) { Fabricate(:user) }

  subject { node }

  it { should be_respond_to :title }
  it { should be_respond_to :status }
  it { should be_respond_to :token }
  it { should be_respond_to :email_send }
  it { should be_valid }

  it "validations" do
    subject.title = ""
    subject.should_not be_valid
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

  describe "Scopes" do
    let(:attrs) { valid_attributes_for(:node)}
    let(:published_node) { node_type.nodes.build(attrs.merge(status: "published")) }
    let(:pending_approval_node) { node_type.nodes.build(attrs.merge(status: "pending_approval")) }
    let(:expired_node) { node_type.nodes.build(attrs.merge(status: "expired")) }
    let(:rejected_node) { node_type.nodes.build(attrs.merge(status: "rejected")) }

    before do
      published_node.save
      pending_approval_node.save
      expired_node.save
      rejected_node.save
    end

    it ".published" do
      subject.class.published.should be_include published_node
      subject.class.published.should_not be_include pending_approval_node
      subject.class.published.should_not be_include expired_node
      subject.class.published.should_not be_include rejected_node
    end

    it ".pending_approval" do
      subject.class.pending_approval.should_not be_include published_node
      subject.class.pending_approval.should be_include pending_approval_node
      subject.class.pending_approval.should_not be_include expired_node
      subject.class.pending_approval.should_not be_include rejected_node
    end

    it ".expired" do
      subject.class.expired.should_not be_include published_node
      subject.class.expired.should_not be_include pending_approval_node
      subject.class.expired.should be_include expired_node
      subject.class.expired.should_not be_include rejected_node
    end

    it ".rejected" do
      subject.class.rejected.should_not be_include published_node
      subject.class.rejected.should_not be_include pending_approval_node
      subject.class.rejected.should_not be_include expired_node
      subject.class.rejected.should be_include rejected_node
    end

    it ".active" do
      subject.class.active.should be_include published_node
      subject.class.active.should be_include pending_approval_node
      subject.class.active.should be_include expired_node
      subject.class.active.should be_include rejected_node
    end
  end

  context "Workflow" do
    it "is new after create" do
      subject.should be_new
    end

    it "is pending approval after submit" do
      subject.submit!
      subject.should be_pending_approval
    end

    it "is published after accept" do
      subject.submit!
      subject.publish!
      subject.should be_published
    end

    it "is rejected after reject" do
      subject.submit!
      subject.reject!
      subject.should be_rejected
    end

    it "is expired after expire" do
      subject.submit!
      subject.publish!
      subject.expire!
      subject.should be_expired
    end
  end
end