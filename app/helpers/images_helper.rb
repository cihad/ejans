module ImagesHelper
  def image_for_mustache(opts)
    uploaded = opts.delete(:uploaded) || true
    {
      image_id:     opts[:image].id,
      image_url:    opts[:image].image_url(:thumb),
      node_id:      opts[:node].id,
      machine_name: opts[:machine_name],
      uploaded:     uploaded
    }
  end
end