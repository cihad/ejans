module Ejans
  module Features
    module FeatureConfigurationAbility
      private
      def where
        where = "features."
        where += "#{parent.feature_type}."
        where += "#{parent.value_name}"
        where
      end
    end
  end
end