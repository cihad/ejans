module Ejans
  module Features
    module SingleValueFeatureConfiguration
      def value_type
        :single
      end

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