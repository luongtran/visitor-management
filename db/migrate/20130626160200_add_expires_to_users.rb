class AddExpiresToUsers < ActiveRecord::Migration
  def change
    add_column :users, :expires, :datetime
  end
end
