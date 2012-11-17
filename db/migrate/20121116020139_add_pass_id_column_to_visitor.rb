class AddPassIdColumnToVisitor < ActiveRecord::Migration
  def change
    add_column :visitors, :pass_id, :string
  end
end
