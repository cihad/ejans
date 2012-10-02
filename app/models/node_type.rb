class NodeType
  include Mongoid::Document
  include Mongoid::Timestamps
  include Rails.application.routes.url_helpers

  attr_accessor :administrator_username_or_email

  field :name, type: String
  validates :name, presence: true

  field :title_label, type: String, default: I18n.t('global.title')
  field :description, type: String
  field :filters_position, type: Symbol, default: :top
  FILTERS_POSITIONS = [:top, :left]
  validates :filters_position, inclusion: { in: FILTERS_POSITIONS }
  
  field :commentable, type: Boolean
  field :node_expiration_day_limit, type: Integer, default: 0

  has_many :nodes
  embeds_many :field_configurations,
    class_name: "Fields::FieldConfiguration"
  embeds_one :node_view, class_name: "Views::Node"
  embeds_one :place_page_view, class_name: "Views::PlacePage"
  embeds_many :views, class_name: "Views::View"

  has_and_belongs_to_many :administrators,
                          class_name: "User",
                          inverse_of: :managed_node_types
  accepts_nested_attributes_for :administrators

  after_create :create_node_view
  validates :name, presence: true

  after_initialize { load_node_class if name }

  after_save :update_node_type_class

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

  def filters
    field_configurations.filters
  end

  def sort_confs
    field_configurations.sort_confs
  end

  def keynames
    field_configurations.map(&:keyname)
  end

  def machine_names
    field_configurations.map(&:machine_name)
  end  

  def fill_random!(node_count = 100)
    node_count.times do
      node = Node.new(title: Faker::Lorem.sentence)
      node.save(validate: false)
      node.node_type = self
      node.fields.each { |f| f.fill_random! }
      node.save(validates: false)
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
    [:node, :node_path] +
    self_data.keys +
    field_configurations.inject([]) do |a, conf|
      a << "node.#{conf.self_data.keys.first}"
    end +
    field_configurations.inject([]) do |a, conf|
      a << conf.self_data.keys.first
    end
  end

  def self_data
    { :"node_type" => self,
      :"node_type_path" => node_type_nodes_path(self) }
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

    sort_confs.each do |conf|
      hash[conf.machine_name.to_sym] = conf.label
    end

    hash
  end

  def filter(params = {})
    nodes.
      publishing.
      send(:where, filter_query(params).selector).
      send(:order_by, sort_query(params).options[:sort]).
      page(params[:page])
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

  def load_node_class
    begin
      node_classify_name.constantize
    rescue
      self.class.const_set node_classify_name.demodulize.to_sym, Class.new(Node)
      node_classify_name.constantize
      field_configurations.each { |conf| conf.load_node }
    end
  end

  private
  def filter_query(params)
    query = NodeQuery.new
    filters.each do |conf|
      query = query.send(:where, conf.filter_query(params).selector)
    end 
    query = query.where(author_id: Moped::BSON::ObjectId(params[:author_id])) if params[:author_id].present?
    query
  end

  def sort_query(params)
    query = NodeQuery.new
    sort_confs.each do |conf|
      query = query.send(:order_by, conf.sort_query(params).options[:sort])
    end
    query = query.send(:order_by, node_spesific_sortable_query(params).options[:sort])
    query
  end

  def node_spesific_sortable_query(params)
    sort = params[:sort]
    direction = params[:direction] || "asc"
    query = NodeQuery.new
    case sort
    when "title"
      query.order_by(:title => direction.to_sym)
    when "created_at"
      query.order_by(:created_at => direction.to_sym)
    else
      NodeQuery.new
    end
  end

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