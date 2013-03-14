class RegistrationsController < ApplicationController
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in :user, @user
      redirect_to({:controller => 'visitors', :action => "new"}, :notice => "Register successfully")
    end
  end
end
