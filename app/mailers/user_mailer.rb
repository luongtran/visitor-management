class UserMailer < ActionMailer::Base
  include Devise::Mailers::Helpers
  default from: "contact@16columns.com"

  def welcome_message(user)
    subject = "Receptionist and Visitors, now happier than ever"
    mail(:to => user.email, :subject => subject)
  end

  def activated_message(user)
  	subject = "Your account is activated for 30 days now."
  	mail(:to => user.email, :subject => subject)
  end
end