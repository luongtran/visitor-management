class Photo < ActiveRecord::Base
  attr_accessible :type, :user_id, :image
  
  has_attached_file :image, :styles => { :small => "150x150>" },
                  :url  => "/assets/photos/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/photos/:id/:style/:basename.:extension"
                  
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/jpg', 'image/gif']
end
