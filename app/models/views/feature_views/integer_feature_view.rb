module Views
  module FeatureViews
    class IntegerFeatureView
      include Mongoid::Document

      # Associations
      embedded_in :feature_view

    end
  end
end