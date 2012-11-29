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
    if @user.update_attributes(params[:user])
      redirect_to me_index_path, :notice => "Updated successfully!"
    end
  end
  
  def edit
    
  end
  
end
