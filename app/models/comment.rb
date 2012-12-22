class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body

  embedded_in :node
  belongs_to :author, class_name: "User", inverse_of: nil
  
  validates :body, presence: true
end
