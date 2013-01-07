require 'spec_helper'

describe NodeView do

  let(:node_type) { Fabricate(:node_type) }

  subject { node_type.node_view }

  it { should be_respond_to :css }
  it { should be_respond_to :js }
  it { should be_respond_to :user_input_node_template }
  it { should be_valid }

  it "#user_input_node_template validation" do
    subject.user_input_node_template = ""
    subject.should_not be_valid
  end

  it "#fill_a_sample_view=" do
    subject.user_input_node_template = ""
    subject.fill_a_sample_view = ""
    subject.user_input_node_template.should_not be_blank
  end

end