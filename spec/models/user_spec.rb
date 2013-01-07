require 'spec_helper'

describe User do
  let(:user) { Fabricate.build(:anonymous_user) }

  subject { user }

  it { should be_respond_to :role }
  it { should be_valid }

  describe "Role" do
    it "status anonymous" do
      should be_anonymous
    end

    it "status registered" do
      subject.signup!
      subject.should be_registered
    end

    it "status pending_for_signup" do
      user = Fabricate.build(:anonymous_user, password: "")
      user.save(validate: false)
      user.should be_pending_for_signup
    end

    it "status admin" do
      user.signup!
      user.admin!
      user.should be_admin
    end
  end

  it "#set_role callback" do
    user.save
    user.should be_registered
  end

  it "#nodes" do
    user.save
    node_type = Fabricate(:node_type)
    node = node_type.nodes.build(valid_attributes_for(:node).merge(author: subject))
    node.save
    user.nodes.should be_include node
  end

  it "when user destroyed node destroyed too" do
    user.save
    node_type = Fabricate(:node_type)
    node = node_type.nodes.build(valid_attributes_for(:node).merge(author: subject))
    node.save
    user.destroy
    expect { Node.find(id: node.id) }.to raise_error Mongoid::Errors::DocumentNotFound
  end

  it "#managed_node_types" do
    node_type = Fabricate(:node_type)
    node_type.administrators << subject
    subject.managed_node_types.should be_include node_type
  end

  it "#own_node_types" do
    subject.save
    node_type = Fabricate(:node_type)
    node_type.super_administrator = subject
    node_type.save
    subject.own_node_types.should be_include node_type
  end
end