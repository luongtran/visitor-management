class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :type
      t.integer :user_id

      t.timestamps
    end
  end
end
