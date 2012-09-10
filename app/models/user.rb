require 'bcrypt'
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  attr_accessor :password,
                :password_confirmation,
                :email_or_username

  field :username
  field :email
  field :password_digest
  field :remember_token

  has_many :nodes, inverse_of: :author, dependent: :destroy

  before_save { |user| user.email = email.downcase }
  before_create :create_remember_token

  USERNAME_REGEX = /\A[A-Za-z0-9_]+\z/
  validates :username,
            presence: true,
            length: { maximum: 50 },
            format: { with: USERNAME_REGEX },
            uniqueness: { case_sensitive: false }

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            presence: true,
            format: { with: EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  validates :password,
            length: { minimum: 6 },
            confirmation: true

  validates :remember_token, uniqueness: true

  def email_name
    email.split('@').first
  end

  def unpublished_nodes
    nodes.unpublished
  end

  def password=(unencrypted_password)
    unless unencrypted_password.blank?
      @password = unencrypted_password
      self.password_digest = BCrypt::Password.create(unencrypted_password)
    end
  end

  def email_or_username=(email_or_username)
    if self.email?(email_or_username)
      @email = email_or_username
    elsif self.username?(email_or_username)
      @username = email_or_username
    end
  end

  def self.email?(email_or_username)
    !!(email_or_username =~ EMAIL_REGEX)
  end

  def self.username?(email_or_username)
    !!(email_or_username =~ USERNAME_REGEX)
  end

  def self.authenticate(email_or_username, password)
    if email?(email_or_username)
      find_by(email: email_or_username).try(:authenticate, password)
    elsif username?(email_or_username)
      find_by(username: email_or_username).try(:authenticate, password)
    end
  end

  def authenticate(unencrypted_password)
    BCrypt::Password.new(password_digest) == unencrypted_password && self
  end

  def self.authenticate_with_token(email, token)
    find_by(email: email).try(:authenticate_with_token, token)
  end

  def authenticate_with_token(token)
    remember_token == token && self
  end

  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end