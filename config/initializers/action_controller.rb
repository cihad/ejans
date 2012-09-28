if Rails.env.production?
  ActionController::Base.asset_host = Rails.configuration.app_config['rackspace_fog_host']
end