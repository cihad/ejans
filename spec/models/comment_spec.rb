require 'spec_helper'

describe Comment do

  let(:node_type) { Fabricate(:node_type) }
  let(:node) { Fabricate(:node) }
  let(:comment) { Fabricate.build(:comment) }

  before do
    node.node_type = node_type
    comment.node = node
  end

  subject { comment }

  it { should be_respond_to :body }
  it { should be_valid }

  context "#embedded_in :node" do
    specify do
      subject.class.
        reflect_on_association(:node).
        should_not be_nil
    end
  end

  context "#validations" do
    specify do
      subject.body = ""
      subject.should_not be_valid
    end
  end
end