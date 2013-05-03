class RegistrationsController < ApplicationController
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in :user, @user
      redirect_to({:controller => 'visitors', :action => "new"})
    else
      i = 0
      @user.errors.full_messages.each do |er|
        flash["error" + i.to_s] = er
        i+=1
      end
      #flash[:error] = "Oops! unexpected errors occurs"
      redirect_to "/login"
    end
  end
  
  def reset_password
    if request.post?
      
    end
    
    respond_to do |format|
      format.html
    end
  end
end
