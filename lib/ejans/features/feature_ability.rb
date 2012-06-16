module Ejans
  module Features
    module FeatureAbility
      def parent
        feature
      end

      def configuration
        feature.feature_configuration
      end

      def child_configuration
        configuration.child
      end

      def required?
        configuration.required?
      end
    end
  end
end
