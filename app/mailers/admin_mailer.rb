class AdminMailer < ActionMailer::Base
  include Devise::Mailers::Helpers
  default from: "contact@16columns.com"
          to:   ["darksundarksun@gmail.com", "darksun8@yandex.ru"]

  def user_registered_message(user)
  	#emails = ["vishant.pai@gmail.com", "vishant.pai@icloud.com"]
  	@user = user
    subject = "34pass.com - User Registered"
    mail(:subject => subject)
  end
end
