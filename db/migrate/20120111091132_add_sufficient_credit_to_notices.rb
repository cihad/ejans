class AddSufficientCreditToNotices < ActiveRecord::Migration
  def change
    add_column :notices, :sufficient_credit, :boolean, :default => true
  end
end
