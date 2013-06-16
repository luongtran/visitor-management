class CreateVisitors < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
      t.string :visitor_name, :null => false
      t.string :visitor_company_name, :null => false
      t.string :visitor_mobile_number, :null => false
      t.string :reason_to_visit, :null => false
      t.string :here_to_meet, :null => false
      t.string :location
      t.string :visitor_vehicle_number
      t.text :storage_device_detail
      t.string :authorized_id
      t.text :comment
      t.integer :user_id

      t.timestamps
    end
  end
end
