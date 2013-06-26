class AddLocationAndZipcodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :location, :string
    add_column :users, :zip_code, :integer
  end
end
