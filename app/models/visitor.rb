class Visitor < ActiveRecord::Base
  
  has_attached_file :photo, :styles => { :small => "150x150>", medium: '300x300>' }
                  
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/jpg', 'image/gif']
  
  validates :visitor_name, :here_to_meet, :visitor_mobile_number, :presence => true
  #validates :badge_number, :presence => true, :on => :save_with_out_print
  
  attr_accessible :authorized_id, :comment, :here_to_meet, :location, :reason_to_visit, :storage_device_detail, :coming_from,
                  :user_id, :visitor_company_name, :visitor_mobile_number, :visitor_name, :visitor_vehicle_number, :pass_id, 
                  :photo, :check_out_time, :badge_number, :status
  
  before_create :set_pass_id
  
  validate :validate_visitor_mobile_number_check_in, :on => :create
  validate :badge_number_not_blank, :on => :save_with_out_print
  validate :validate_badge_number, :on => :create
  validate :valid_mobile_number?
  #phony_normalize :visitor_mobile_number, :default_country_code => 'IN'
  
  # validates_plausible_phone :visitor_mobile_number, :presence => true
  # validates_plausible_phone :visitor_mobile_number, :with => /^\+\d+/
  # validates_plausible_phone :visitor_mobile_number, :without => /^\+\d+/
  # validates_plausible_phone :visitor_mobile_number, :presence => true, :with => /^\+\d+/

  belongs_to :user

  
  def set_pass_id
    current = Time.now
    pass_id = current.month.to_s + current.hour.to_s + current.min.to_s + current.sec.to_s
    rand_num = [*1000..9999].sample
    pass_id += rand_num.to_s
    # begin
      # pass_id += rand_num.to_s
    # rescue => e
#       
    # end
    
    self.pass_id = pass_id
  end
  
  def self.expired_ones
    where(status: "Expired" )
  end
  
  def self.checked_out
    where(status: "Checked Out" )
  end
  
  def self.insiders(user_id)
    where(status: "Inside", user_id: user_id)
  end
  
  def self.get_visitors(user_id)
    where('user_id = ?', user_id)
  end
  
  def self.search(word, key, user_id)
    puts "@"*30
    puts "Word: #{word}, key: #{key}"
    if !key.nil?
      key = key.downcase
    end
    if word.present? && key.present?
      puts "Am in word if block"
      where("user_id = ? AND (lower(#{word}) like ?)", user_id, "%#{key.downcase}%")
    elsif !word.present? && key.present?
      where('user_id = ? AND (LOWER(visitor_name) like ? OR LOWER(visitor_company_name) like ? OR pass_id like ? OR here_to_meet like ? OR badge_number like ? OR visitor_company_name like ? OR visitor_mobile_number like ?)', 
                              user_id, "%#{key}%", "%#{key}%", "%#{key}%", "%#{key}%", "%#{key}%", "%#{key}%", "%#{key}%")
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
    if !badge_number.blank?
      visitor = Visitor.find(:first, :conditions => ['badge_number = ? AND user_id = ? AND check_out_time is null', badge_number, user_id])
      if !visitor.nil?
        errors.add(:badge_number, "#{badge_number} must be checked out")
      end
    end
  end
  
  def validate_visitor_mobile_number_check_in
    visitor = Visitor.find(:first, :conditions => ["visitor_mobile_number = ? AND user_id = ? AND check_out_time is null", visitor_mobile_number, user_id])
    if !visitor.nil?
      errors.add(:visitor_mobile_number, "#{visitor_mobile_number} must be checked out")
    end
  end

  def valid_mobile_number?
    if self.visitor_mobile_number.match /[a-zA-Z]/
      errors.add(:visitor_mobile_number, " should not include characters")
    end
  end
  
end
