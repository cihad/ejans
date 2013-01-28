require 'spec_helper'

describe CurrentView do

  let(:node_type) { Fabricate(:full_featured_node_type) }

  it "select default view" do
    expect(CurrentView.new(node_type, nil).view.class).to eq DefaultNodeTypeView
  end

  it "select first view" do
    view = Fabricate(:node_type_view, node_type: node_type)
    expect(CurrentView.new(node_type, nil).view).to eq view
  end

  it "select requested view" do
    view = Fabricate(:node_type_view, node_type: node_type)
    other_view = Fabricate(:node_type_view, node_type: node_type)
    expect(CurrentView.new(node_type, view.id).view).to eq view
    expect(CurrentView.new(node_type, other_view.id).view).to eq other_view
  end
end