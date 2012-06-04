module Views
  class NodeView
    include Mongoid::Document

    # Assocations
    embedded_in :view, class_name: "Views::View"
  end
end