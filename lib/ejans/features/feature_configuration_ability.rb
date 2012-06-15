module Ejans
  module Features
    module FeatureConfigurationAbility

      def parent
        feature_configuration
      end

      # if label == "Price"
      # => "price"
      def machine_name
        feature_configuration.machine_name
      end
    end
  end
end