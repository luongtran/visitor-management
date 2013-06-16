class ChangeColumnDataTypeVisitor < ActiveRecord::Migration
  def up
  end

  def down
  end
  
  def change
     change_column :visitors, :storage_device_detail, :string 
  end
  
end
