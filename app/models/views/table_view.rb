module Views
  class TableView
    include Mongoid::Document

    # Assocations
    embedded_in :view, class_name: "Views::View"
  end
end