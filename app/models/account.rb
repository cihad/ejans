class Account < ActiveRecord::Base

  STARTER_CREDIT = 100

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # Associations
  has_many :own_services, :foreign_key => "owner_id", :class_name => "Service"
  has_many :subscriptions
  has_many :notices, :through => :subscriptions
  has_many :services, :through => :subscriptions
  has_one :credit, :as => :creditable
  has_and_belongs_to_many :roles, :limit => 1
  has_many :notifications, :as => :notificationable

  # Callbacks
  after_create :add_starter_credit
  after_create :add_role

  def add_starter_credit
    self.create_credit(:credit => STARTER_CREDIT)
  end

  def add_role
    if Account.first == self
      admin_role = "Admin".underscore
      role = Role.create(:name => admin_role)
      self.roles << role
    else
      authenticated_role = "Authenticated".underscore
      role = Role.find_by_name(authenticated_role) || Role.create(:name => authenticated_role)
      self.roles << role
    end
  end

  def subscribing?(service)
    self.subscriptions.find_by_service_id(service.id) ? true : false
  end

  def role?(role)
    if roles.first.present?
      roles.first.name == role.to_s
    else
      false
    end
  end
end
