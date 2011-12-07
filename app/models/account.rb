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
  has_one :account_credit

  # Callbacks
  after_create :add_account_credit

  def add_account_credit
    self.create_account_credit(:credit => STARTER_CREDIT)
  end
end
