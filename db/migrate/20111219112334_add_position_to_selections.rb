class AddPositionToSelections < ActiveRecord::Migration
  def change
    add_column :selections, :position, :integer
  end
end
