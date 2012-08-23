class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :node
  field :body, type: String

  validates :body, presence: true
end
