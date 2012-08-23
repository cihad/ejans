require 'spec_helper'

describe Node do
  let(:node_type) { Fabricate(:node_type) }
  let(:node) { Fabricate.build(:node) }

  before do
    node.node_type = node_type
  end

  subject { node }

  it { should be_respond_to :title }
  it { should be_respond_to :created_at }
  it { should be_respond_to :updated_at }
  it { should be_respond_to :comments }
  it { should be_valid }

  context "#comments" do
    specify do
      subject.class.
        reflect_on_association(:comments).
        should_not be_nil
    end
  end

  context "#validations" do
    specify do
      subject.title = ""
      subject.should_not be_valid
    end
  end
end