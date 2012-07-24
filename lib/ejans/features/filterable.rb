module Ejans
  module Features
    module Filterable
      def self.included(base)
        base.class_eval do
          # extend ClassMethods
          # include InstanceMethods
          field :filter, type: Boolean
        end
      end

      # module ClassMethods;end
      # module InstanceMethods; end
    end
  end
end
