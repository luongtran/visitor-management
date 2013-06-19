class CreateHereToMeets < ActiveRecord::Migration
  def change
    create_table :here_to_meets do |t|
      t.string :name
      t.string :mobile_number
      t.string :email
      t.string :organization

      t.timestamps
    end
  end
end
