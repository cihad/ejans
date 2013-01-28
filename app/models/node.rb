class Node
  include Mongoid::Document
  include Mongoid::Timestamps
  include Rails.application.routes.url_helpers
  include CustomFields::Target
  include Workflow

  attr_accessor :author_email

  # Kaminari
  paginates_per 20

  # Workflow
  workflow_column :status

  # Fields
  field :title
  field :status
  field :token
  field :email_send, type: Boolean
  field :node_view

  # Associations
  belongs_to  :node_type, index: true
  belongs_to  :author, class_name: 'User', inverse_of: :nodes, index: true
  embeds_many :comments

  # Scopes
  default_scope                 order_by(created_at: :desc)
  scope :published,             where(status: "published")
  scope :pending_approval,      where(status: "pending_approval")
  scope :expired,               where(status: "expired")
  scope :rejected,              where(status: "rejected")
  scope :active,                ne(status: "new")
  scope :time_ago_updated,      ->(time) { where(:updated_at.lt => time) }
  scope :blank_nodes_by_author, where({"$and"=>[{"title"=>nil}, {"author_id"=>{"$exists"=>true}}]})

  # Validations
  validates :title, presence: true
  validate  :is_user_email_valid

  # Callbacks
  before_save     :save_user
  after_save      :send_email
  before_create   :set_random_token
  before_save     :fill_node_view

  # Indexes
  index title: 1
  index status: 1
  index created_at: 1
  index updaed_at: 1
  index({ node_type_id: 1, status: 1, _type: 1, created_at: 1 }, { background: true })

  # Workflow for node status
  workflow do
    state :new do
      event :submit, :transitions_to => :pending_approval
    end

    state :pending_approval do
      event :submit, :transitions_to => :pending_approval
      event :publish, :transitions_to => :published
      event :reject, :transitions_to => :rejected
    end

    state :published do
      event :submit, :transitions_to => :published
      event :expire, :transitions_to => :expired
    end

    state :expired do
      event :submit, :transitions_to => :pending_approval
    end

    state :rejected do
      event :submit, :transitions_to => :pending_approval
    end
  end

  ## TODO: presenter
  def path
    node_type_node_path(node_type_id, self.id)
  end

  ## TODO: presenter
  def self_data
    { :"node" => self }
  end

  ## TODO: presenter
  def mapping(field_data)
    field_data.merge(self_data).merge(node_type.self_data)
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

  def fill_node_view
    node_template = node_type.node_view.node_template
    self.node_view = NodeViewPresenter.new(node_template, self, node_type).to_s
    if node_type.node_type_views.exists?
      node_type.node_type_views.each do |v|
        self["view_#{v.id}"] = NodeViewPresenter.new(v.node_template, self, node_type).to_s
      end
    else
      self["view_default"] = NodeViewPresenter.new(DefaultNodeTypeView.new.node_template, self, node_type).to_s
    end
  end

end