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

  # Results by param filters
  # query(params).selector => {:price => { "$gte" => 100, $lte => "200"}}
  def filter(params = {})
    nodes
      .send(:where, query(params).selector)
      .page(params[:page])
  end

  private
  # return OriginObject
  # #<NodeQuery:0xc2ad8dc @serializers={}, @driver=:moped, @aliases={}, @selector={}, @options={}, @strategy=nil, @negating=nil> 
  def query(params)
    node_query = NodeQuery.new
    filters.each do |conf|
      node_query = node_query.send(:where, conf.filter_query(params))
    end 
    node_query
  end

  def create_node_view
    self.views.build({}, Views::Node).save(validate: false)
  end
end