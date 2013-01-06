require 'spec_helper'

describe Comment do

  let(:user) { Fabricate(:user) }
  let(:node) { Fabricate(:node) }
  let(:comment) { Fabricate.build(:comment, node: node, author: user) }

  subject { comment }

  it { should be_respond_to :body }
  it { should be_valid }

  it "#node" do
    subject._parent.should == node
  end

  it "#author validation" do
    subject.author = nil
    subject.should_not be_valid
  end

  it "#body validation" do
    subject.body = ""
    subject.should_not be_valid
  end
end