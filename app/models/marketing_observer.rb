class MarketingObserver < Mongoid::Observer
  def after_create(marketing)
    marketing_template = marketing.marketing_template

    marketing.potential_users.each do |potential_user|
      NodeTypeMailer.invitation(marketing_template, potential_user).deliver
    end
  end
end