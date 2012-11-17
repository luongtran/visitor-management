class Visitor < ActiveRecord::Base
  
  has_attached_file :photo, :styles => { :small => "150x150>" },
                  :url  => "/assets/visitors/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/visitors/:id/:style/:basename.:extension"
                  
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/jpg', 'image/gif']
  
  validates :visitor_name, :visitor_company_name, :here_to_meet, :visitor_mobile_number, :reason_to_visit, :presence => true

  
  attr_accessible :authorized_id, :comment, :here_to_meet, :location, :reason_to_visit, :storage_device_detail, 
                  :user_id, :visitor_company_name, :visitor_mobile_number, :visitor_name, :visitor_vehicle_number, :pass_id, :photo
  
  before_create :set_pass_id
  
  def set_pass_id
    current = Time.now
    pass_id = current.year.to_s + current.month.to_s + current.hour.to_s + current.min.to_s
    rand_num = rand(10000..99999)
    pass_id += rand_num.to_s
    self.pass_id = pass_id
  end
  
end
