module ImagesHelper
  def image_for_mustache(image, node, uploaded = true)
    {
      image_id: image.id,
      image_url: image.image_url,
      node_id: node.id,
      uploaded:  uploaded
    }
  end
end