module ModalHelper
  def modal(title, &block)
    content_tag :div do
      render layout: "shared/modal", locals: { title: title }, &block
    end
  end

  def pjax_modal(title, param, &block)
    close_path = delete_param!(param)
    content_tag :div, data: { pjax_modal: true } do
      if params[param]
        render layout: "shared/pjax_modal", locals: { title: title, close_path: close_path }, &block
      end
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

  def link_to_pjax_modal(title, prm = {})
    prms = delete_param!
    link_to(title, url_for(prms.merge(prm)), class: "btn btn-mini pjax_modal")
  end

  def link_to_pjax_modal_close
    close_path = delete_param!(:node_id)
    link_to url_for(close_path), class: "pjax_modal" do
      button_tag type: 'button', class: 'close' do
        concat("&times;".html_safe)
      end
    end
  end

  def link_to_modal(title)
    link_to title, "#Modal", class: "btn", data: { toggle: "modal" }
  end
end