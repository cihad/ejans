class NodeType
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  field :name, type: String
  field :title_label, type: String
  field :title_help, type: String
  field :description, type: String, as: 'desc'
  field :description_label, type: String, as: 'desc_label'
  field :description_help, type: String

  # Associations
  has_many :nodes
  has_many :feature_configurations, class_name: "Features::FeatureConfiguration"
  has_many :views, class_name: "Views::View"

  # Callbacks
  after_save :create_node_view

  def create_node_view
    self.views.create(type: :node, position: 0)
  end

  # Methods
  # Feature configurations with selected filter
  def filters
    feature_configurations.where(filter: true)
  end

  # Feature configurations' configurations
  def filters_children
    filters.collect(&:child)
  end

  # Results by param filters
  # query(params).selector => {:price => { "$gte" => 100, $lte => "200"}}
  def filter(params = {})
    nodes
      .includes(features: :feature_configuration)
      .send(:where, query(params).selector)
      .page(params[:page])
  end

  Views::View::VIEW_TYPES.each do |view_type|
    define_method(:"#{view_type}_features") do
      views.includes(features: :feature_configuration).find_by(type: view_type).features
    end
  end

  private
  # return OriginObject
  # #<NodeQuery:0xc2ad8dc @serializers={}, @driver=:moped, @aliases={}, @selector={}, @options={}, @strategy=nil, @negating=nil> 
  def query(params)
    node_query = NodeQuery.new
    filters_children.each do |fco|
      node_query = node_query.send(:where, fco.filter_query(params))
    end 
    node_query
  end
end