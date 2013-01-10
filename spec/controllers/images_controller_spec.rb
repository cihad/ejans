require 'spec_helper'

describe ImagesController do


  let(:user) { Fabricate(:user) }
  let(:node_type) { Fabricate(:full_featured_node_type) }
  let(:node) { NewNode.new(node_type, user).node }

  before do
    signin user
  end

  it "#update" do
  end

  it "#destroy" do
    machine_name = node_type.nodes_custom_fields.select { |f| f.type == "image" }.first.machine_name
    node.fill_with_random_values
    node.save(validate: false)

    image = node.send(machine_name).first

    delete :destroy, id: image.id, node_id: node.id, node_type_id: node_type.id, machine_name: machine_name
    response.should be_success
  end

end