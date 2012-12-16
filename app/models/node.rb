class Node
  include Mongoid::Document
  include Mongoid::Timestamps
  include Rails.application.routes.url_helpers
  include CustomFields::Target

  attr_accessor :author_email

  # Kaminari
  paginates_per 20

  # Fields
  field :title
  field :published,   type: Boolean, default: false
  field :approved,    type: Boolean, default: false
  field :token
  field :email_send,  type: Boolean

  # Associations
  belongs_to  :node_type
  belongs_to  :author, class_name: 'User', inverse_of: :nodes
  embeds_many :comments

  # Scopes
  default_scope                     order_by(created_at: :desc)
  scope :published,                 where(published: true)
  scope :not_published,             where(published: false)
  scope :approved,                  where(approved: true)
  scope :not_approved,              where(approved: false)
  scope :queue_for_approve,         where(published: true, approved: false)
  scope :waiting_for_user_action,   not_published.not_approved
  scope :listing,                   published.approved
  scope :time_ago_updated,          ->(time) { where(:updated_at.lt => time) }
  scope :blank_nodes_by_anon,       where(title: nil).and(author: nil)
  scope :blank_nodes_by_author,     where({"$and"=>[{"title"=>nil}, {"author_id"=>{"$exists"=>true}}]})

  # Validations
  validates :title, presence: true
  validate  :is_user_email_valid

  # Callbacks
  before_save     :save_user
  after_save      :send_email
  before_create   :set_random_token
  before_save     :set_publish

  # Indexes
  index title: 1

  { integer: 4,
    string: 3,
    date: 2 }.each do |key_prefix, how_many|
    how_many.times.each_with_index do |i|
      index "#{key_prefix}_#{i}" => 1
    end
  end

  { place_value: 2 }.each do |key_prefix, how_many|
    how_many.times.each_with_index do |i|
      index "#{key_prefix}_#{i}_ids" => 1
    end
  end

  { list_item: 4 }.each do |key_prefix, how_many|
    how_many.times.each_with_index do |i|
      index "#{I18n.with_locale(:en) { i.to_words }}_#{key_prefix}_ids" => 1
    end
  end

  def publish=(value)
    self.published = true
  end

  def approve=(value)
    self.approved = true
  end

  def in_queue_for_approve?
    published? and !approved?
  end

  def listing?
    published? and approved?
  end

  def list!
    self.published  = true
    self.approved   = true
    save
  end

  def unlist!
    self.published  = false
    self.approved   = false
    save
  end

  def path
    node_type_node_path(node_type, self)
  end

  def self_data
    { :"node" => self }
  end

  def mapping(conf_data)
    conf_data.merge(self_data).merge(node_type.self_data)
  end
  
  def author_email=(email)
    @user = User.find_or_initialize_by(email: email)
    self.send_email = true
    self.email_send = true
    self.author = @user
    @author_email = @user.email
  end

  def author_email
    @author_email ||= author.try(:email)
  end

  def send_email?
    @send_email ||= false
  end

  def send_email=(true_or_false = false)
    @send_email = true_or_false
  end

  def can_manage?(user)
    user == author || node_type.administrators.include?(user)
  end

  def fill_with_random_values
    node_type.nodes_custom_fields.each do |field| field.fill_node_with_random_value(self) end
  end

  private
  def send_email
    delivered = NodeMailer.node_info(self).deliver if send_email?
  end

  def set_random_token
    self.token = SecureRandom.urlsafe_base64
  end

  def is_user_email_valid
    if @user and @user.new_record? and !@user.valid? and @user.errors.messages[:email].present?
      errors.add :author_email, "Gecerli bir e-mail adresi giriniz."
    end
  end

  def save_user
    @user.save(validate: false) if @user
  end

  def set_publish
    self.published = true if valid?
  end
end