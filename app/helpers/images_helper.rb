module ImagesHelper
  def image_for_mustache(opts)
    uploaded = opts.delete(:uploaded) || true
    {
      image_id: opts[:image].id,
      image_url: opts[:image].image_url(:thumb),
      node_id: opts[:node].id,
      keyname: opts[:keyname],
      uploaded: uploaded
    }
  end
end