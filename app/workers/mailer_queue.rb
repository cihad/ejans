class MailerQueue
  @queue = :mailer_queue

  def self.perform(mailer_id, node_type_id)
    mailer = NodeType.find(node_type_id).mailers.find(mailer_id)
    mailer_template = mailer.mailer_template

    mailer.potential_users.each do |potential_user|
      NodeTypeMailer.notify(mailer_template, potential_user).deliver
    end

    Rails.logger.info "MAILER: Basarili bir sekilde #{mailer.potential_users.size} kisiye mail gonderildi"
  end
end