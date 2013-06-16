class AddStatusFieldToVisitors < ActiveRecord::Migration
  def change
    add_column :visitors, :status, :string, default: "Inside"
  end
end
