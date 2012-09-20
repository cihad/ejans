ActionMailer::Base.smtp_settings = {
  address:              APP_CONFIG['smtp_address'],
  port:                 APP_CONFIG['smtp_port'].to_i,
  domain:               APP_CONFIG['smtp_domain'],
  authentication:       :login,
  enable_starttls_auto: true,
  user_name:            APP_CONFIG['smtp_username'],
  password:             APP_CONFIG['smtp_password']
}