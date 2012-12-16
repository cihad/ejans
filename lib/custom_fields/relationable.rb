module CustomFields
  module Relationable
    extend ActiveSupport::Concern

    included do
      field :class_name
      field :inverse_of

      validates_presence_of :class_name
    end

    def relation?
      self.class.relation?
    end

    module ClassMethods
      def relation?
        true  
      end
    end

  end
end