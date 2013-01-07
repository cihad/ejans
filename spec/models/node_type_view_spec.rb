require 'spec_helper'

describe NodeTypeView do
  
  let(:node_type) { Fabricate(:node_type) }
  let(:node_type_view) { Fabricate(:node_type_view, node_type: node_type) }

  subject { node_type_view }

  it { should be_respond_to :css }
  it { should be_respond_to :js }
  it { should be_respond_to :user_input_node_type_template }
  it { should be_respond_to :user_input_node_template }
  it { should be_respond_to :position }
  it { should be_respond_to :icon }
  it { should be_valid }

  it "#user_input_node_template validation" do
    subject.user_input_node_template = ""
    subject.should_not be_valid
  end

  it "embedded_in node_type" do
    subject._parent.should == node_type
  end

  it "default scope" do
    subject.position = 1
    subject.save
    other_view = Fabricate(:node_type_view, position: 2, node_type: node_type)
    node_type.node_type_views.should == [subject, other_view]
  end
  
  it "#view_count validation" do
    # 1. view
    subject.save

    # 2. view
    Fabricate(:node_type_view, node_type: node_type)

    # ignored
    Fabricate.build(:node_type_view, node_type: node_type).should_not be_valid
  end

end