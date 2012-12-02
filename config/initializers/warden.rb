Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = SessionsController.action(:new)
end

Warden::Manager.serialize_into_session do |user|
  user.remember_token
end

Warden::Manager.serialize_from_session do |remember_token|
  User.find_by(remember_token: remember_token)
end

Warden::Strategies.add(:password) do
  def valid?
    params['session']['email_or_username'] && params['session']['password']
  end

  def authenticate!
    user = User.authenticate(params['session']['email_or_username'], params['session']['password'])
    user ? success!(user) : fail!(I18n.t('sessions.invalid_information'))
  end
end