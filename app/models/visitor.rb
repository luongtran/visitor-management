class Visitor < ActiveRecord::Base
  
  has_attached_file :photo, :styles => { :small => "150x150>" },
                  :url  => "/assets/visitors/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/visitors/:id/:style/:basename.:extension"
                  
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/jpg', 'image/gif']
  
  validates :visitor_name, :visitor_company_name, :here_to_meet, :visitor_mobile_number, :reason_to_visit, :badge_number, :presence => true

  
  attr_accessible :authorized_id, :comment, :here_to_meet, :location, :reason_to_visit, :storage_device_detail, 
                  :user_id, :visitor_company_name, :visitor_mobile_number, :visitor_name, :visitor_vehicle_number, :pass_id, :photo, :check_out_time, :badge_number
  
  before_create :set_pass_id
  
  def set_pass_id
    current = Time.now
    pass_id = current.year.to_s + current.month.to_s + current.hour.to_s + current.min.to_s + current.sec.to_s
    # rand_num = Random.rand(10000..99999)
    # begin
      # pass_id += rand_num.to_s
    # rescue => e
#       
    # end
    
    self.pass_id = pass_id
  end
  
  def self.get_visitors(user_id)
    where('user_id = ?', user_id)
  end
  
  def self.search(key, user_id)
    key = key.downcase
    if key
      where('user_id = ? AND (LOWER(visitor_name) like ? OR LOWER(visitor_company_name) like ? OR pass_id like ?)', 
                              user_id, "%#{key}%", "%#{key}%", "%#{key}%")
    else
      where('user_id = ?', user_id)
    end
  end
  
end
