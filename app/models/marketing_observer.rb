class MarketingObserver < Mongoid::Observer
  def after_create(marketing)
    Resque.enqueue(MarketingQueue, marketing.id, marketing.node_type.id)
  end
end