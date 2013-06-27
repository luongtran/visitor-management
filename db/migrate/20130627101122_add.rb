class Add < ActiveRecord::Migration
  def change
  	add_column :visitors, :user_location, :string
  	add_column :visitors, :zip_code,      :integer
  end
end
