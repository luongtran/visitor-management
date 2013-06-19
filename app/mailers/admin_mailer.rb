class AdminMailer < ActionMailer::Base
  include Devise::Mailers::Helpers
  default from: "contact@16columns.com"

  def user_registered_message(user)
  	@user = user
    subject = "34pass.com - User Registered"
    mail(:to => "vishant.pai@gmail.com",  :subject => subject)
    mail(:to => "vishant.pai@icloud.com", :subject => subject)

  end
end
