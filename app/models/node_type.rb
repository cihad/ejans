class NodeType
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::FullTextSearch
  include Rails.application.routes.url_helpers
  include CustomFields::Source

  attr_accessor :administrator_email
  
  # Behaviours
  custom_fields_for :nodes

  # Fields
  field :name
  field :title_label,               default: I18n.t('node_types.default_label')
  field :description
  field :commentable,               type: Boolean
  field :signin_required,           type: Boolean
  field :node_expiration_day_limit, type: Integer, default: 0
  field :nodes_count,               type: Integer, default: 0

  # Validates
  validates :name, presence: true
  validates :title_label, presence: true

  # Indexes
  index nodes_count: 1

  # Associations
  has_many    :nodes, dependent: :destroy
  embeds_one  :node_view, autobuild: true
  embeds_one  :place_page_view
  embeds_many :node_type_views
  embeds_many :mailer_templates
  embeds_many :mailers
  has_and_belongs_to_many :potential_users
  has_and_belongs_to_many :administrators, class_name: "User",
                          inverse_of: :managed_node_types
  accepts_nested_attributes_for :administrators
  belongs_to  :super_administrator, class_name: "User", inverse_of: :own_node_types

  # Scopes
  scope :sort_by_nodes_count, ->(dir = :desc) { send(dir, :nodes_count) }

  # Class Methods
  def self.search(search = nil)
    if search.present?
      ::Metadata.fulltext_search(search)
                .map(&:document)
                .uniq
                .sort { |doc1, doc2| doc1.nodes_count <=> doc2.nodes_count }
    else
      sort_by_nodes_count
    end
  end

  def self.unpublish_expired_nodes!
    all.each do |nt| nt.set_not_publish_for_expired_nodes end
  end

  # Instance Methods
  def searchables
    labels = nodes_custom_fields.map(&:label)
    select_fields = nodes_custom_fields.where("_type" => CustomFields::Fields::Select::Field)
    option_names = select_fields.inject([]) do |options, field|
      options += field.options.map(&:name)
    end

    [name] + labels + option_names
  end

  def expired_nodes
    if node_expiration_day_limit > 0
      nodes.published.time_ago_updated(node_expiration_day_limit.days.ago)
    else
      []
    end
  end

  def set_not_publish_for_expired_nodes
    expired_nodes.each do |node| node.unlist! end
  end

  def filtered_fields
    nodes_custom_fields.filtered_fields
  end

  def sortable_fields
    nodes_custom_fields.sortable_fields
  end

  def keynames
    nodes_custom_fields.map(&:keyname)
  end

  def machine_names
    nodes_custom_fields.map(&:machine_name)
  end

  def related_node_types
    ids = nodes_custom_fields.exists(class_name: true).map(&:class_name).map do |class_name|
      self.class.class_name_to_node_type_id(class_name)
    end

    self.class.in(id: ids)
  end

  def potential_users=(emails)
    emails.split("\n").each do |email|
      email.strip!
      if potential_user = PotentialUser.find_or_create_by(email: email)
        potential_users << potential_user unless potential_users.include?(potential_user)
      end
    end
  end

  # TODO: this is a presenter method
  def node_template_attrs
    ["node"] +
    self_data.keys +
    nodes_custom_fields.inject([]) do |a, field|
      a << "node.#{field.machine_name}"
    end +
    nodes_custom_fields.inject([]) do |a, field|
      a << field.to_recipe['machine_name']
    end
  end

  # TODO: this is a presenter method
  def nodes_path
    node_type_nodes_path(self)
  end

  # TODO: this is a presenter method
  def self_data
    { :"node_type" => self }
  end

  # TODO: this is a presenter method
  def field_data
    nodes_custom_fields.inject({}) do |h, field|
      h.merge!(field.self_data)
    end
  end

  # TODO: this is a presenter method
  def sort_data
    hash = {
      title: title_label,
      created_at: I18n.t('node_types.created')
    }

    sortable_fields.each do |field|
      hash[field.machine_name.to_sym] = field.label
    end

    hash
  end

  def administrator_email=(email)
    user = User.where(email: email).first
    self.administrators << user if user and !administrator_ids.include?(user.id)
  end

  def self.class_name_to_node_type_id(class_name)
    $1 if class_name =~ /^Node(.*)/
  end

  def self.class_name_to_node_type(class_name)
    find(class_name_to_node_type_id(class_name))
  end
end