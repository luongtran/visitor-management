class AddComingFromColumnToVisitor < ActiveRecord::Migration
  def change
    add_column :visitors, :coming_from, :string
  end
end
