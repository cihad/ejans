module ModalHelper
  def modal(title, &block)
    content_tag :div do
      render layout: "shared/modal", locals: { title: title }, &block
    end
  end

  def node_modal_path(node)
    prms = delete_param!(:node_id)
    url_for(prms.merge(node_id: node.id.to_s))
  end

  def delete_param!(param = nil)
    prms = params.clone
    prms.delete(param) if param
    prms
  end

  def link_to_modal(title)
    link_to title, "#modal", class: "btn", data: { toggle: "modal" }
  end

  def static_modal(title, &block)
    render layout: 'shared/static_modal', locals: { title: title }, &block
  end
end