class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  ## fields
  field :body

  ## associations
  embedded_in :node
  belongs_to :author, class_name: "User", inverse_of: nil
  
  ## validations
  validates :body, presence: true
  validates :author, presence: true
  
end
