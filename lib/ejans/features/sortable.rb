module Ejans
  module Features
    module Sortable
      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end

      module ClassMethods

      end
    end
  end
end
