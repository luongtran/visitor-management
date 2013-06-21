class AdminMailer < ActionMailer::Base
  include Devise::Mailers::Helpers
  default from: "contact@16columns.com",
          to:   ["vishant.pai@gmail.com", "vishant.pai@icloud.com"]

  def user_registered_message(user)
  	@user = user
    subject = "34pass.com - User Registered"
    mail(:subject => subject)
  end
end
