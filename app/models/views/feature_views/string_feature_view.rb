module Views
  module FeatureViews
    class StringFeatureView
      include Mongoid::Document

      # Associations
      embedded_in :feature_view

    end
  end
end