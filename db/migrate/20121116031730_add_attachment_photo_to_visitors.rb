class AddAttachmentPhotoToVisitors < ActiveRecord::Migration
  def self.up
    change_table :visitors do |t|
      t.has_attached_file :photo
    end
  end

  def self.down
    drop_attached_file :visitors, :photo
  end
end
