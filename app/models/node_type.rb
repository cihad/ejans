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

  # Methods
  # Feature configurations with selected filter
  def filters
    feature_configurations.where(filter: true)
  end

  # Feature configurations' configurations
  def filters_configuration_objects
    filters.collect(&:configuration_object)
  end

  # Results by param filters
  # query(params).selector => {:price => { "$gte" => 100, $lte => "200"}}
  def filter(params = {})
    nodes.send(:where, query(params).selector)
  end

  private
  # return OriginObject
  # #<NodeQuery:0xc2ad8dc @serializers={}, @driver=:moped, @aliases={}, @selector={}, @options={}, @strategy=nil, @negating=nil> 
  def query(params)
    node_query = NodeQuery.new
    filters_configuration_objects.each do |fco|
      node_query = node_query.send(:where, fco.filter_query(params))
    end 
    node_query
  end
end