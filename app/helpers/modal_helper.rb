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
    prms.delete(:_pjax)
    prms.delete(:_pjax_return)
    prms
  end

  def link_to_modal(title)
    link_to title, "#Modal", class: "btn", data: { toggle: "modal" }
  end
end