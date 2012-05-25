class NodeType
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  field :name, type: String
  field :title_label, type: String
  field :title_help, type: String
  field :description, type: String, as: 'desc'
  field :description_label, type: String, as: 'desc_label'
  field :description_help, type: String
  has_many :nodes
  has_many :feature_configurations, class_name: "Features::FeatureConfiguration", autosave: true

  def filters
    feature_configurations.where(filter: true)
  end

  def filters_configuration_objects
    filters.collect(&:configuration_object)
  end

  def queries(params)
    filters_configuration_objects.inject([]) do |a, fco|
      fco.filter_query(params).each do |query|
        a << query
      end
      a
    end 
  end

  def filter(params = {})
    results = nodes
    queries(params).each do |query|
      results = results.send(:where, query)
    end
    results
  end
end