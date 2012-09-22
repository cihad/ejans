CarrierWave.configure do |config|

  config.cache_dir = File.join(Rails.root, 'tmp', 'uploads')

  if Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      provider:             'Rackspace',
      rackspace_username:   APP_CONFIG['rackspace_username'],
      rackspace_api_key:    APP_CONFIG['rackspace_api_key'],
      rackspace_servicenet: true
    }
    config.fog_directory = APP_CONFIG['rackspace_fog_directory']
    config.fog_host = APP_CONFIG['rackspace_fog_host']
  else
    config.storage = :file
    config.root = File.join(Rails.root, 'public')
  end
end