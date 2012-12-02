ActionMailer::Base.smtp_settings = {
  address:              Rails.configuration.app_config['smtp_address'],
  port:                 Rails.configuration.app_config['smtp_port'].to_i,
  domain:               Rails.configuration.app_config['smtp_domain'],
  authentication:       :login,
  enable_starttls_auto: true,
  user_name:            Rails.configuration.app_config['smtp_username'],
  password:             Rails.configuration.app_config['smtp_password']
}