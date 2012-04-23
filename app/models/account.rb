# == Schema Information
#
# Table name: accounts
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

class Account < ActiveRecord::Base
  include Ejans::Noticable

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
  has_many :ideas
  has_many :comments, :foreign_key => "author_id", :class_name => "Comment"

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

  def subscription(service)
    subscriptions.find_by_service_id(service.id)
  end

  def subscribing?(service)
    self.subscriptions.find_by_service_id(service.id) ? true : false
  end

  def role?(role)
    roles.first.present? ? roles.first.name == role.to_s : false # roles self
  end

  def admin?
    roles.first.name == "admin"
  end

  def owner_notification?(notification)
    self == notification.notificationable
  end
end
