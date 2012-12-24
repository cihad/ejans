class NodesQuery

  attr_reader :node_type, :params
  attr_accessor :criteria

  def initialize(node_type, params = {}, relation = nil, criteria = NullCriteria.new)
    @node_type = node_type
    @params = params
    @relation = relation || node_type.nodes.unscoped.published
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

  def filtered_fields
    @filtered_fields ||= node_type.filtered_fields
  end

  def selections
    field_selectors
    author_selector
  end

  def field_selectors
    filtered_fields.each do |field|
      self.criteria = criteria.send(:where, field.filter_query(params).selector)
    end
  end

  def author_id
    params[:author_id]
  end

  def author_selector
    if author_id.present?
      self.criteria = criteria.where(author_id: Moped::BSON::ObjectId(author_id))
    end
  end

  def sortable_fields
    @sortable_fields ||= node_type.sortable_fields
  end

  def options
    field_options
    node_spesific_options
  end

  def field_options
    sortable_fields.each do |config|
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