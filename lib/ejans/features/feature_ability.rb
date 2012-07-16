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

      def value
        self.send(configuration.value_name)
      end
    end
  end
end
