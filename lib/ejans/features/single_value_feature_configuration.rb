module Ejans
  module Features
    module SingleValueFeatureConfiguration
      def value_type
        :single
      end

      private
      def where
        where = "features."
        where += "#{parent_feature_configuration.feature_type}."
        where += "#{parent_feature_configuration.value_name}"
        where
      end
    end
  end
end