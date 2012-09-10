class Node
  include Mongoid::Document
  include Mongoid::Timestamps
  include Rails.application.routes.url_helpers

  paginates_per 20
  attr_accessor :author_email

  # Fields
  field :title
  index title: 1

  field :published, type: Boolean, default: false
  field :approved, type: Boolean, default: false
  field :token

  # Validations
  validates :title, presence: true
  validate :valid_email

  # Associations
  belongs_to :author, class_name: 'User', inverse_of: :nodes

  # Scopes
  scope :approved_queue, where(published: true, approved: false)
  scope :unpublished, where(published: false)
  scope :publishing, where(published: true, approved: true)
  scope :time_ago_published, ->(time) { where(:updated_at.lt => time) }

  # Associations
  belongs_to :node_type
  embeds_many :features, class_name: "Features::Feature"
  accepts_nested_attributes_for :features
  embeds_many :comments

  # Callbacks
  after_initialize :build_values
  after_save :send_email
  before_create :set_random_token

  # Indexes
  { integer_value: 4,
    string_value: 3,
    date_value: 2 }.each do |feature_value, how_many|
    how_many.times.each_with_index do |i|
      index "features.#{feature_value}_#{i}" => 1
    end
  end

  { place_value: 2 }.each do |feature_value, how_many|
    how_many.times.each_with_index do |i|
      index "features.#{feature_value}_#{i}_ids" => 1
    end
  end

  { list_item: 4 }.each do |feature_value, how_many|
    how_many.times.each_with_index do |i|
      index "features.#{I18n.with_locale(:en) { i.to_words }}_#{feature_value}_ids" => 1
    end
  end

  def publish=(submit_value)
    self.published = true
    self.approved = false
  end

  def set_approved
    self.published = true
    self.approved = true
    self.save
  end

  def set_unpublishing
    self.published = false
    self.approved = false
    self.save
  end

  def find_value_by_views_feature(feature)
    fcid = feature.feature_configuration_id
    features.where(feature_configuration_id: fcid).first
  end

  def data
    { :node_id => id.to_s,
      :node_title => title,
      :node_url => node_type_node_path(node_type, self),
      :node_created_at => created_at,
      :node_updated_at => updated_at }
  end

  def self.data_names
    [:node_id, :node_title, :node_url, :node_created_at, :node_updated_at]
  end

  def mapping(conf_data)
    features_data = features.inject({}) do |hash, feature|
      hash.merge!(feature.data(conf_data))
    end

    node_data = data.merge(features_data)

    conf_data = conf_data.inject({}) do |hash, conf|
      hash.merge!(conf.last[:data])
    end

    node_data.merge(conf_data)
  end

  def build_assoc!
    node_type.feature_configurations.each do |conf|
      conf.build_assoc!(self)
    end
  end

  def fill_random!
    features.each do |f|
      f.fill_random!
    end
  end

  def node_type=(node_type)
    self.node_type_id = node_type.id
    build_assoc!
  end

  def author_email=(email)
    email.strip!
    user = begin
            User.find_by(email: email)
          rescue
            User.new(email: email).save(validate: false)
          end

    self.send_email = true
    self.author = user
    @author_email = user.email
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

  private
  def build_values
    build_assoc! if node_type
  end

  def send_email
    delivered = NodeMailer.node_info_mailer(self).deliver if send_email?
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