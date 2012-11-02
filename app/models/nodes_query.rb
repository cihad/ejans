class NodesQuery

  attr_reader :node_type, :params
  attr_accessor :criteria

  def initialize(node_type, params = {}, relation = nil, criteria = BlankCriteria.new)
    @node_type = node_type
    @params = params
    @relation = relation || node_type.nodes.unscoped.publishing
    @criteria = criteria
    load_criteria
  end

  def load_criteria
    selections
    options
  end

  def results
    @relation.
      send(:where, criteria.selector).
      send(:order_by, criteria.options[:sort]).
      page(params[:page])
  end

  def filter_configs
    @filter_configs ||= node_type.filter_configs
  end

  def selections
    config_selections
    author_selection
  end

  def config_selections
    filter_configs.each do |config|
      self.criteria = criteria.send(:where, config.filter_query(params).selector)
    end
  end

  def author_id
    params[:author_id]
  end

  def author_selection
    if author_id.present?
      self.criteria = criteria.where(author_id: Moped::BSON::ObjectId(author_id))
    end
  end

  def sortable_configs
    @sortable_configs ||= node_type.sortable_configs
  end

  def options
    config_options
    node_spesific_options
  end

  def config_options
    sortable_configs.each do |config|
      self.criteria = criteria.send(:order_by, config.sort_query(params).options[:sort])
    end
  end

  def direction
    (params[:direction].present? ? params[:direction] : "desc").to_sym
  end

  def sort
    (params[:sort].present? ? params[:sort] : "created_at").to_sym
  end

  def node_spesific_options
    self.criteria = criteria.order_by(sort => direction) if sort
  end
end