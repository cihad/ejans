module CustomFields
  module Sortable
    extend ActiveSupport::Concern

    included do
      field :sort, type: Boolean, default: false
    end

    def sort_query(params = {})
      sort = params[:sort]
      direction = params[:direction] || "asc"
      if sort? and sort == machine_name
        criteria = BlankCriteria.new
        criteria = criteria.order_by(keyname => direction.to_sym)
        criteria
      else
        BlankCriteria.new
      end
    end

    def sortable?
      self.class.sortable?
    end

    module ClassMethods
      def sortable?
        true
      end
    end

  end
end
