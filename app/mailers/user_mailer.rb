class UserMailer < ActionMailer::Base
  include Devise::Mailers::Helpers
  default from: "contact@16columns.com"

  def welcome_message(user)
    subject = "Manage Visitors, easily"
    mail(:to => user.email, :subject => subject)
  end
end
