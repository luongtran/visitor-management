class AddBadgeNumberToVisitor < ActiveRecord::Migration
  def change
    add_column :visitors, :badge_number, :string
  end
end
