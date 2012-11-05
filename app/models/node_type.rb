class NodeType
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::FullTextSearch
  include Rails.application.routes.url_helpers

  attr_accessor :administrator_username_or_email

  mount_uploader :background_image, BackgroundImageUploader

  field :name, type: String
  validates :name, presence: true

  field :title_label, type: String, default: I18n.t('global.title')
  field :description, type: String
  field :filters_position, type: Symbol, default: :top
  FILTERS_POSITIONS = [:top, :left]
  validates :filters_position, inclusion: { in: FILTERS_POSITIONS }
  
  field :commentable, type: Boolean
  field :signin_required, type: Boolean
  field :node_expiration_day_limit, type: Integer, default: 0

  has_many :nodes, dependent: :destroy
  embeds_many :field_configurations,
    class_name: "Fields::FieldConfiguration"
  embeds_one :node_view, class_name: "Views::Node"
  embeds_one :place_page_view, class_name: "Views::PlacePage"
  embeds_many :views, class_name: "Views::View"

  embeds_many :marketing_templates
  embeds_many :marketing
  has_and_belongs_to_many :potential_users
  has_and_belongs_to_many :administrators,
                          class_name: "User",
                          inverse_of: :managed_node_types
  accepts_nested_attributes_for :administrators

  after_create :create_node_view
  validates :name, presence: true

  after_initialize { load_node_model if name }

  after_save :update_node_type_class

  def self.search(search = nil)
    if search
      ::Metadata.fulltext_search(search).map(&:document).uniq
    else
      all
    end
  end

  def searchables
    labels = field_configurations.map(&:label)
    list_field_configs = field_configurations.where("_type" => Fields::ListFieldConfiguration)
    list_field_item_names = list_field_configs.inject([]) do |items, config|
      items += config.list_items.map(&:name)
    end

    [name] + labels + list_field_item_names
  end

  def self.unpublish_expired_nodes!
    all.each do |node_type|
      node_type.set_unpublishing_expired_nodes
    end
  end

  def self.remove_blank_nodes_by_anon!
    all.each do |node_type|
      node_type.remove_blank_nodes_by_anon!
    end
  end

  def self.remove_blank_nodes_by_author!
    all.each do |node_type|
      node_type.remove_blank_nodes_by_author!
    end
  end

  def approved_queue
    nodes.approved_queue
  end

  def expired_nodes
    if node_expiration_day_limit > 0
      nodes.publishing.time_ago_updated(node_expiration_day_limit.days.ago)
    else
      []
    end
  end

  def set_unpublishing_expired_nodes
    expired_nodes.each do |node|
      node.set_unpublishing
      node.save
    end
  end

  def remove_blank_nodes_by_anon!
    nodes.blank_nodes_by_anon.destroy
  end

  def remove_blank_nodes_by_author!
    nodes.
      blank_nodes_by_author.
      time_ago_updated(Node::REMOVE_BLANK_NODES_IN_X_DAY.days.ago).
      destroy
  end

  def publishing_nodes
    nodes.publishing
  end

  def filter_configs
    field_configurations.filter_configs
  end

  def sortable_configs
    field_configurations.sortable_configs
  end

  def keynames
    field_configurations.map(&:keyname)
  end

  def machine_names
    field_configurations.map(&:machine_name)
  end

  def related_node_types
    NodeType.or(
      { "field_configurations.child_nodes_node_type_id" => self.id },
      { "field_configurations.parent_node_node_type_id" => self.id }
    )
  end

  def potential_users=(emails)
    emails.split("\n").each do |email|
      email.strip!
      if potential_user = PotentialUser.find_or_create_by(email: email)
        potential_users << potential_user unless potential_users.include?(potential_user)
      end
    end
  end
  
  def build_configuration(params)
    type = params[:_type].safe_constantize
    if Fields::FieldConfiguration.subclasses.include?(type)
      parameters =  params[Fields::FieldConfiguration.param_name(type)] || 
                    params[:fields_field_configuration]
      self.field_configurations.build(parameters, type)
    end
  end

  def build_view(params)
    type = params[:_type].safe_constantize if params[:_type]
    if Views::View.sub_classes.include?(type)
      parameters = params[Views::View.param_name(type)] || {}
      self.views.build(parameters, type)
    end
  end

  def node_template_attrs
    [:node] +
    self_data.keys +
    field_configurations.inject([]) do |a, conf|
      a << "node.#{conf.self_data.keys.first}"
    end +
    field_configurations.inject([]) do |a, conf|
      a << conf.self_data.keys.first
    end
  end

  def nodes_path
    node_type_nodes_path(self)
  end

  def self_data
    { :"node_type" => self }
  end

  def conf_data
    field_configurations.inject({}) do |h, conf|
      h.merge!(conf.self_data)
    end
  end

  def sort_data
    hash = {
      title: title_label,
      created_at: I18n.t('global.created')
    }

    sortable_configs.each do |conf|
      hash[conf.machine_name.to_sym] = conf.label
    end

    hash
  end

  def inverse_of_administrators_association
    self.class.reflect_on_association(:administrators).inverse_of
  end

  def add_administrator(user)
    administrators << user
    user.send("#{inverse_of_administrators_association}") << self
  end

  def remove_administrator(user)
    administrators.delete(user)
    user.send("#{inverse_of_administrators_association}").delete(self)
  end

  def administrator_username_or_email=(username_or_email)
    begin
      user = User.find_by_username_or_email(username_or_email)
      self.administrators << user
      user.send("#{inverse_of_administrators_association}") << self
    rescue
    end
  end

  def node_classify_name
    "NodeType::" + name.parameterize('_').classify
  end

  def form_parameterize
    node_classify_name.underscore.parameterize("_")
  end

  def load_node_model
    begin
      node_classify_name.constantize
    rescue
      build_node_model
    end
  end

  def build_node_model
    self.class.const_set node_classify_name.demodulize.to_sym, Class.new(Node)
    node_classify_name.constantize
    field_configurations.each { |conf| conf.load_node }
  end

  def refresh_node_model
    build_node_model
  end

  private
  def create_node_view
    self.build_node_view.save(validate: false)
  end

  def update_node_type_class
    if name_changed?
      nodes.each do |node|
        node._type = node_classify_name
        node.save(validate: false)
      end
    end
  end
end