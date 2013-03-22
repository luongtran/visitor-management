class RegistrationsController < ApplicationController
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in :user, @user
      redirect_to({:controller => 'visitors', :action => "new"}, :notice => "Register successfully")
    else
      flash[:error] = "Oops! unexpected errors occurs"
    end
  end
end
