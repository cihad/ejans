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

      def value_name
        configuration.value_name.to_sym
      end

      def required?
        configuration.required?
      end

      def add_error(field = :base, message = "")
        errors.add(field, message)
      end

      def value
        self.send(value_name)
      end
    end
  end
end
