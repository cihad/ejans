class Node
  include Mongoid::Document
  include Mongoid::Timestamps
  include Rails.application.routes.url_helpers

  paginates_per 20
  attr_accessor :author_email

  REMOVE_BLANK_NODES_IN_X_DAY = 30

  # Fields
  field :title
  index title: 1

  field :published, type: Boolean, default: false
  field :approved, type: Boolean, default: false
  field :token
  field :email_send, type: Boolean

  # Validations
  validates :title, presence: true
  validate :valid_email

  # Associations
  belongs_to :author, class_name: 'User', inverse_of: :nodes

  # Scopes
  scope :approved_queue, where(published: true, approved: false)
  scope :published, where(published: true)
  scope :unpublished, where(published: false).exists(title: true)
  scope :publishing, where(published: true, approved: true)
  scope :time_ago_updated, ->(time) { where(:updated_at.lt => time) }
  scope :blank_nodes_by_anon, where(title: nil).and(author: nil)
  scope :blank_nodes_by_author, where({"$and"=>[{"title"=>nil}, {"author_id"=>{"$exists"=>true}}]})

  # Associations
  belongs_to :node_type
  embeds_many :comments

  # Callbacks
  after_save :send_email
  before_create :set_random_token

  # Indexes
  { integer_value: 4,
    string_value: 3,
    date_value: 2 }.each do |key_prefix, how_many|
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

  def publish=(submit_value)
    self.published = true
    self.approved = false
  end

  def approve=(submit_value)
    self.published = true
    self.approved = true
  end

  def save_no_validate=(submit_value)
    @save_no_validate = true
  end

  def save_no_validate?
    @save_no_validate
  end

  def statement_save
    save_no_validate? ? self.save(validate: false) : self.save
  end

  def set_approved
    self.published = true
    self.approved = true
    self.save
  end

  def set_unpublishing
    self.published = false
    self.approved = false
  end

  def saved?
    !!self.title.blank?
  end

  def node_path
    node_type_node_path(node_type, self)
  end

  def self_data
    { :"node" => self }
  end

  def mapping(conf_data)
    conf_data.merge(self_data).merge(node_type.self_data)
  end
  
  def author_email=(email)
    email.strip!
    if User::EMAIL_REGEX =~ email
      user = begin
              User.find_by(email: email)
            rescue
              user = User.new(email: email)
              user.save(validate: false)
              user
            end

      self.send_email = true
      self.email_send = true
      self.author = user
      @author_email = user.email
    else
      @author_email = email
    end
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

  private
  def send_email
    delivered = NodeMailer.node_info(self).deliver if send_email?
  end

  def set_random_token
    self.token = SecureRandom.urlsafe_base64
  end

  def valid_email
    unless author_email =~ User::EMAIL_REGEX
      errors.add(:author_email, "Gecerli bir e-mail adresi giriniz.")
    end
  end
end