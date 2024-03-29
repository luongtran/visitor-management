class RegistrationsController < ApplicationController
  
  respond_to :html, :json

  def create
    logger = Logger.new('log/signup.log')
    logger.info("============Log for signup in controller===============")
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
      logger.info(new_user_registration_path)
      #redirect_to new_user_registration_path(@user)
      respond_with @user, :location => new_user_registration_path
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
