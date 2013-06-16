class AddCheckOutColumnToVisitor < ActiveRecord::Migration
  def change
    add_column :visitors, :check_out_time, :datetime
  end
end
