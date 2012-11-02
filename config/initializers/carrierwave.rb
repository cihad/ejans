CarrierWave.configure do |config|

  config.cache_dir = File.join(Rails.root, 'tmp', 'uploads')

  if Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      provider:             'Rackspace',
      rackspace_username:   Rails.configuration.app_config['rackspace_username'],
      rackspace_api_key:    Rails.configuration.app_config['rackspace_api_key'],
      rackspace_servicenet: true
    }
    config.fog_directory = Rails.configuration.app_config['rackspace_fog_directory']
    config.asset_host = Rails.configuration.app_config['rackspace_fog_host']
  else
    config.storage = :file
    config.root = File.join(Rails.root, 'public')
  end
end