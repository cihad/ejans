module Views
  module NodeViews
    class ListView
      include Mongoid::Document

      # list_tag selections
      LIST_TAGS = [:ul, :ol, :div]

      # Fields
      field :list_tag, type: Symbol

      # Assocations
      embedded_in :view
    end
  end
end