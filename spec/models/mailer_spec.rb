require 'spec_helper'

describe Mailer do

  let(:node_type) { Fabricate(:node_type) }
  let(:potential_user) { Fabricate(:potential_user) }
  let(:mailer_template) { Fabricate(:mailer_template, node_type: node_type) }
  let(:mailer) { Fabricate.build(:mailer, node_type: node_type, mailer_template_id: mailer_template.id) }

  before do
    node_type.potential_users << potential_user
    mailer.potential_users = node_type.potential_users 
  end

  subject { mailer }

  it { should be_respond_to :mailer_template_id }
  it { should be_respond_to :status }
  it { should be_respond_to :mailer_template }
  it { should be_valid }

  it "#mailer_template_id validtion" do
    subject.mailer_template_id = nil
    subject.should_not be_valid
  end

  it "#mailer_template" do
    subject.mailer_template.should == mailer_template
  end

  it "embbedded_in node_type" do
    subject._parent.should == node_type
  end

  it "workflow" do
    subject.should be_pending
    subject.save
    subject.transport!
    subject.should be_sended
  end


end