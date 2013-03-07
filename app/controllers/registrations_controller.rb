class RegistrationsController < ApplicationController
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in :user, @user
      redirect_to({:controller => 'dashboard', :action => "index"}, :notice => "Register successfully")
    end
  end
end
