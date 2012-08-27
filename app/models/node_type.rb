class NodeType
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :title_label, type: String
  field :description, type: String
  field :filters_position, type: Symbol, default: :top
  FILTERS_POSITIONS = [:top, :left]
  field :commentable, type: Boolean

  has_many :nodes
  has_many :feature_configurations,
    class_name: "Features::FeatureConfiguration",
    dependent: :destroy
  has_many :views, class_name: "Views::View",
    dependent: :destroy

  after_create :create_node_view
  validates :name, presence: true
  validates :filters_position,
    inclusion: { in: FILTERS_POSITIONS }

  def filters
    feature_configurations.filters
  end

  def sort_confs
    feature_configurations.sort_confs
  end

  def removable_views
    views.reject { |view| view.class == Views::Node }
  end

  def node_view
    (views - removable_views).first
  end

  def key_names
    feature_configurations.map(&:key_name)
  end

  def fill_random!(node_count = 100)
    node_count.times do
      node = Node.new(title: Faker::Lorem.sentence)
      node.save(validate: false)
      node.node_type = self
      node.features.each { |f| f.fill_random! }
      node.save(validates: false)
    end
  end

  def build_configuration(params)
    type = params[:_type].safe_constantize if params[:_type]
    if Features::FeatureConfiguration.subclasses.include?(type)
      parameters = params[Features::FeatureConfiguration.param_name(type)] || {}
      self.feature_configurations.build(parameters, type)
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
    Node.data_names +
    feature_configurations.inject([]) do |arr, conf|
      arr + conf.data_names
    end
  end

  def conf_data
    feature_configurations.inject({}) do |h, conf|
      h.merge!(conf.conf_data)
    end
  end

  def sort_data
    hash = {
      title: "Title",
      created_at: "Created at"
    }

    sort_confs.each do |conf|
      hash[conf.machine_name.to_sym] = conf.label
    end

    hash
  end

  def filter(params = {})
    nodes.
      send(:where, filter_query(params).selector).
      send(:order_by, sort_query(params).options[:sort]).
      page(params[:page])
  end

  private
  def query(params)
    query = filter_query(params)
    query = query.send(:where, sort_query(params).options)
    query
  end

  def filter_query(params)
    query = NodeQuery.new
    filters.each do |conf|
      query = query.send(:where, conf.filter_query(params).selector)
    end 
    query
  end

  def sort_query(params)
    query = NodeQuery.new
    sort_confs.each do |conf|
      query = query.send(:order_by, conf.sort_query(params).options[:sort])
    end
    query
  end

  def create_node_view
    self.views.build({}, Views::Node).save(validate: false)
  end
end