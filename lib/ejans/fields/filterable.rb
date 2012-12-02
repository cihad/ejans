module Ejans
  module Fields
    module Filterable
      def self.included(base)
        base.class_eval do
          extend ClassMethods
          field :filter, type: Boolean
        end
      end
    end
  end
end
