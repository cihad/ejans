module Ejans
  module Features
    module SingleValueFeature
      def value
        self.send(configuration.value_name)
      end
    end
  end
end