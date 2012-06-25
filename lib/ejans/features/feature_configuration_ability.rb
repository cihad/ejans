module Ejans
  module Features
    module FeatureConfigurationAbility

      def parent
        feature_configuration
      end

      def value_name
        parent.value_name
      end

      def feature_type
        parent.feature_type
      end

      # if label == "Price"
      # => "price"
      def machine_name
        parent.machine_name
      end
    end
  end
end