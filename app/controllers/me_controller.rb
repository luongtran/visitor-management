class MeController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    
  end
  
  
  def change_password
    @user = current_user
    
    if @user.update_with_password(params[:user])
      sign_in(@user, :bypass => true)
      redirect_to me_index_path, :notice => "Password updated!"
    else
      render :edit
    end
  end
  
  def edit
    @user = current_user
  end
  
  def upload_logo
    @user = current_user
  end
  
  def update_organisation
    @user = current_user
  end
  
  def update
    @user = current_user
    notice = ""
    if (!params[:user][:password].empty? && !params[:user][:password].nil?)
      if @user.update_with_password(params[:user])
        sign_in(@user, :bypass => true)
        notice = "Password has been changed successfully"
      end
    else
      if @user.update_attributes({:logo => params[:user][:logo]})
        notice = "Updated successfully!"
      end
    end
    redirect_to me_index_path, :notice => notice
  end
  
  def edit
    
  end
  
end
