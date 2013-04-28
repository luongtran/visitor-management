class Visitor < ActiveRecord::Base
  
  has_attached_file :photo, :styles => { :small => "150x150>" },
                  :url  => "/assets/visitors/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/visitors/:id/:style/:basename.:extension"
                  
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/jpg', 'image/gif']
  
  validates :visitor_name, :here_to_meet, :visitor_mobile_number, :presence => true
  #validates :badge_number, :presence => true, :on => :save_with_out_print
  
  attr_accessible :authorized_id, :comment, :here_to_meet, :location, :reason_to_visit, :storage_device_detail, :coming_from,
                  :user_id, :visitor_company_name, :visitor_mobile_number, :visitor_name, :visitor_vehicle_number, :pass_id, :photo, :check_out_time, :badge_number
  
  before_create :set_pass_id
  
  validate :badge_number_not_blank, :on => :save_with_out_print
  validate :validate_badge_number, :on => :create
  validate :validate_visitor_mobile_number_check_in, :on => :create
  #phony_normalize :visitor_mobile_number, :default_country_code => 'IN'
  
  # validates_plausible_phone :visitor_mobile_number, :presence => true
  # validates_plausible_phone :visitor_mobile_number, :with => /^\+\d+/
  # validates_plausible_phone :visitor_mobile_number, :without => /^\+\d+/
  # validates_plausible_phone :visitor_mobile_number, :presence => true, :with => /^\+\d+/

  
  def set_pass_id
    current = Time.now
    pass_id = current.year.to_s + current.month.to_s + current.hour.to_s + current.min.to_s + current.sec.to_s
    rand_num = [*10000..99999].sample
    pass_id += rand_num.to_s
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
    if !key.nil?
      key = key.downcase
    end
    
    if key
      where('user_id = ? AND (LOWER(visitor_name) like ? OR LOWER(visitor_company_name) like ? OR pass_id like ? OR here_to_meet like ? OR badge_number like ? OR visitor_company_name like ?)', 
                              user_id, "%#{key}%", "%#{key}%", "%#{key}%", "%#{key}%", "%#{key}%", "%#{key}%")
    else
      where('user_id = ?', user_id)
    end
  end
  
  def save_with_out_print
    self.save
  end
  
  def save_print
    self.save
  end
  
  def badge_number_not_blank 
    if badge_number.empty?
      errors.add(:badge_number, "You must enter badge number")
    end
  end
  
  def validate_badge_number
    visitor = Visitor.find(:first, :conditions => ['badge_number = ? AND user_id = ? AND check_out_time is null', badge_number, user_id])
    if !visitor.nil?
      errors.add(:badge_number, "You must check out badge number #{badge_number}")
    end
  end
  
  def validate_visitor_mobile_number_check_in
    visitor = Visitor.find(:first, :conditions => ["visitor_mobile_number = ? AND user_id = ? AND check_out_time is null", visitor_mobile_number, user_id])
    if !visitor.nil?
      errors.add(:visitor_mobile_number, "Visitor with mobile number #{visitor_mobile_number} must be checked out")
    end
  end
  
end
