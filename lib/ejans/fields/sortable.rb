module Ejans
  module Fields
    module Sortable
      def self.included(base)
        base.class_eval do
          # extend ClassMethods
          include InstanceMethods
          field :sort, type: Boolean
        end
      end

      # module ClassMethods; end

      module InstanceMethods
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
      end
    end
  end
end
