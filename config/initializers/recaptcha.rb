Recaptcha.configure do |config|
  config.public_key  = Rails.configuration.app_config['recaptcha_public_key']
  config.private_key = Rails.configuration.app_config['recaptcha_private_key']
end