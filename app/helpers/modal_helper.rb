module ModalHelper
  def pjax_modal(title, close_path, &block)
    render layout: "shared/pjax_modal", locals: { title: title, close_path: close_path }, &block
  end

  def modal(title, param, &block)
    close_path = delete_param!(param)
    content_tag :div, data: { pjax_modal: true } do
      if params[param]
        pjax_modal title, close_path, &block
      end
    end
  end

  def delete_param!(param = nil)
    prms = params.clone
    prms.delete(param) if param
    prms.delete(:_pjax)
    prms.delete(:_pjax_return)
    prms
  end

  def link_to_modal(title, prm = {})
    prms = delete_param!
    link_to(title, url_for(prms.merge(prm)), class: "pjax_modal")
  end
end