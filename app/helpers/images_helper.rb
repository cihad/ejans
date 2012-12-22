module ImagesHelper
  def image_for_mustache(opts)
    node  = opts.delete(:node)
    image = opts.delete(:image)
    {
      image_id:     image.id,
      image_url:    image.image_url(:thumb),
      uploaded:     opts.delete(:uploaded) || true,
      destroy_path: node_type_node_image_path(
                      node.node_type_id,
                      node,
                      image,
                      machine_name: opts[:machine_name],
                      token: opts[:token])
    }
  end
end