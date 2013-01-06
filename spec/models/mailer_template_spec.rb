require 'spec_helper'

describe MailerTemplate do

  let(:node_type) { Fabricate(:node_type) }
  let(:mailer_template) { Fabricate(:mailer_template, node_type: node_type) }

  subject { mailer_template }

  it { should respond_to :title  }
  it { should respond_to :subject  }
  it { should respond_to :template  }
  it { should be_valid }

  it "#title validation" do
    subject.title = ""
    subject.should_not be_valid
  end

  it "#subject validation" do
    subject.subject = ""
    subject.should_not be_valid
  end

  it "#template validation" do
    subject.template = ""
    subject.should_not be_valid
  end

  it "#node_type" do
    subject._parent.should == node_type
  end

end