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
  field :role, type: Symbol, default: :registered
  ROLES = [:anonymous, :registered, :authenticated, :admin]
  before_create { self.role = :admin if User.all.size == 0 }

  has_many :nodes, inverse_of: :author, dependent: :destroy
  has_and_belongs_to_many :managed_node_types,
                          class_name: "NodeType",
                          inverse_of: :administrators
  before_save { |user| user.email = email.downcase }
  before_create :create_remember_token
  before_create :create_password_digest

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

  validate :already_sign_up

  validates :password,
            length: { minimum: 6 },
            confirmation: true,
            on: :create

  validates :remember_token, uniqueness: true

  def email_name
    email.split('@').first
  end

  def username_or_email_name
    username || email_name
  end

  def unpublished_nodes(node_type)
    nodes.unpublished.where(node_type: node_type)
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

  def self.find_by_username_or_email(email_or_username)
    if email?(email_or_username)
      find_by(email: email_or_username)
    elsif username?(email_or_username)
      find_by(username: email_or_username)
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
      where(email: email_or_username).first.try(:authenticate, password)
    elsif username?(email_or_username)
      where(username: email_or_username).first.try(:authenticate, password)
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

  def default_password_changed?
    BCrypt::Password.new(password_digest) != remember_token
  end

  ROLES.each do |role_name|
    define_method "#{role_name}?" do
      role == role_name 
    end

    define_method "make_#{role_name}!" do
      self.role = role_name
      self.save(validate: false)  
    end
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def create_password_digest
    unless password_digest
      self.password_digest = BCrypt::Password.create(remember_token)
    end
  end

  def already_sign_up
    user = User.where(email: email).first
    if !user.nil? and user.username.nil? and !user.default_password_changed?
      user = User.where(email: email).first
      errors.add(:already_sign_up, "Daha once bu email ile sitemizde bazi
                                    aktivitelerde bulunmussunuz. Bundan dolayi
                                    kullanici hesabiniz zaten acilmis durumda.
                                    Hesabiniza kavusabilmeniz #{user.email} adresinize
                                    bir baglanti gonderdik. Bu baglanti ile 
                                    hesabiniza kavusabilirsiniz.")
    end
  end
end