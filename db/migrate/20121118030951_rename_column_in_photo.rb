class RenameColumnInPhoto < ActiveRecord::Migration
  def change
    rename_column :photos, :type, :im_type
  end
end
