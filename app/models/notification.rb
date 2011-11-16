class Notification < ActiveRecord::Base
  # Callbacks
  after_destroy :destroy_selections

  # Associations
  belongs_to :service
  has_and_belongs_to_many :selections

  # Methods
  def destroy_selections
    self.selections.destroy_all
  end
end
