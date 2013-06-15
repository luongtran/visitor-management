class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_attached_file :logo, :styles => { :small => "120x90>" },
                  :url  => "/assets/logo/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/logo/:id/:style/:basename.:extension"
                  
  validates_attachment_size :logo, :less_than => 5.megabytes
  validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png', 'image/jpg', 'image/gif']

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :remember_me, :organisation_name, :logo
  # attr_accessible :title, :body

  validate :organisation_name_cannot_blank
  after_create :welcome_message, :user_registered_message

  def organisation_name_cannot_blank
    if organisation_name.blank?
      errors.add(:organisation_name, "We require Organization name to print on your visitor badge")
    end
  end

  def welcome_message
    UserMailer.welcome_message(self).deliver
  end

  def user_registered_message
    AdminMailer.user_registered_message.deliver
  end

end
