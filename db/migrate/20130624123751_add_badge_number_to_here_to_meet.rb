class AddBadgeNumberToHereToMeet < ActiveRecord::Migration
  def change
    add_column :here_to_meets, :badge_nubmer, :string
  end
end
