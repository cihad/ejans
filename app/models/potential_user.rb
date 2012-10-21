  class PotentialUser
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  field :email
  validates_format_of :email, with: User::EMAIL_REGEX
  field :tags, type: Array, default: []

  def self.create_potential_users(params)
    tags = params[:tag].split(',')
    emails = params[:emails]
    node_type = NodeType.find(params[:node_type_id])

    added_user = 0

    email_array = emails.split("\n").map(&:strip)

    email_array.each do |email|
      if potential_user = PotentialUser.find_or_create_by(email: email)
        tags.each do |tag|
          potential_user.tags << tag unless potential_user.tags.include?(tag)
        end
        unless node_type.potential_users.include?(potential_user)
          node_type.potential_users << potential_user
          added_user += 1
        end
      end
    end

    [added_user, email_array.size]
  end
end