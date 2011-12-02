class Account < ActiveRecord::Base
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

end
