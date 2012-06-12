module ViewsHelper
  def link_to_modal_node(title, node, &block)
    link_to title,
      url_for(params.merge(node_id: node.id)),
      class: "popup-node",
      &block
  end

  def link_to_modal_close
    prms = params.clone
    prms.delete(:node_id)
    prms.delete(:_pjax_return)
    prms.delete(:_pjax)
     link_to url_for(prms), class: "popup-node" do
      button_tag type: 'button', class: 'close' do
        concat("&times;".html_safe)
      end
    end
  end
end