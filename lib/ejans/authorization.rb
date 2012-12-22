module Ejans
  module Authorization
    extend ActiveSupport::Concern

    included do
      
      before_filter :authorize

      delegate :allow?, to: :current_permission
      helper_method :allow?

      private

      def current_permission
        @current_permission ||= Permission.new(current_user, params.clone)
      end

      def current_resource
        @current_resource
      end

      def current_warning
        @current_warning || t('errors.not_authorized')
      end

      def authorize(opts = {})
        @current_warning = opts.delete(:message) if opts[:message]
        unless current_permission.allow?(params[:controller], params[:action], current_resource)
          redirect_to root_path, alert: current_warning
        end
      end

    end
  end
end