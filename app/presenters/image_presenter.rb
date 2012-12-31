class ImagePresenter

  include Rails.application.routes.url_helpers

  def initialize(image)
    @image = image
  end

  def machine_name
    @image._parent.custom_fields_recipe["rules"].find { |r| r["keyname"] == @image.metadata.name }["machine_name"]
  end

  def node
    @node ||= @image._parent
  end

  def destroy_path
    node_type_node_image_path(
      node.node_type_id,
      node.id,
      @image,
      machine_name: machine_name,
      token: node.token)
  end

  def as_json
    {
      "url"         => @image.image_url(:thumb),
      "delete_url"  => destroy_path,
      "delete_type" => "DELETE" 
    }
  end

end