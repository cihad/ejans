module Views
  class ListView
    include Mongoid::Document

    # list_tag selections
    LIST_TAGS = [:ul, :ol, :div]

    # Fields
    field :list_tag, type: Symbol

    # Assocations
    embedded_in :view, class_name: "Views::View"
  end
end