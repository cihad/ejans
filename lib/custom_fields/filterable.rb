module CustomFields
  module Filterable
    extend ActiveSupport::Concern

    included do
      field :filter, type: Boolean, default: false
    end

    def filterable?
      self.class.filterable?
    end

    module ClassMethods
      def filterable?
        true
      end
    end

  end
end
