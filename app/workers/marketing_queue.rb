class MarketingQueue
  @queue = :marketing_queue

  def self.perform(marketing_id, node_type_id)
    marketing = NodeType.find(node_type_id).marketing.find(marketing_id)
    marketing_template = marketing.marketing_template

    marketing.potential_users.each do |potential_user|
      NodeTypeMailer.notify(marketing_template, potential_user).deliver
    end
  end
end