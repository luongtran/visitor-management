class MeController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    
  end
  
  
  def change_password
    @user = current_user
    
    if @user.update_with_password(params[:user])
      sign_in(@user, :bypass => true)
      flash[:info] = "Password has been changed successfully"
      redirect_to me_index_path
    else
      flash[:alert] = "Problem occured while changing your password"
      redirect_to me_index_path
    end
  end

  def excel_import
    if HereToMeet.import(params[:excel_file], current_user)
      flash[:info] = "Successfully imported"
      redirect_to me_index_path
    else
      flash[:alert] = "Problem occured while importing. 
                       Notice that only .xls and .xlsx file types are supported"
      redirect_to me_index_path
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

     if @user.update_attributes(params[:user])
      flash[:info] = "Organization has been changed successfully"
      redirect_to me_index_path
    else
      flash[:alert] = "Problem occured while changing organization"
      redirect_to me_index_path
    end
  end

  def update_location
    @user = current_user

    if @user.update_attributes(params[:user])
      flash[:info] = "Location and zip code has been changed successfully"
      redirect_to me_index_path
    else
      flash[:alert] = "Problem occured while changing location and zip code"
      redirect_to me_index_path

    end
  end

  def update
    @user = current_user
    notice = ""
    #if (!params[:user][:password].empty? && !params[:user][:password].nil?)
    if (!params[:user][:password].empty? && !params[:user][:password].nil?)
      if @user.update_with_password(params[:user])
        sign_in(@user, :bypass => true)
        flash[:info] = "Password has been changed successfully"
        if params[:change_organisation_name]
          flash[:success] = "Hurray! Company name is sucessfully modified"
        end
      end
    else
      if params[:change_organisation_name]
        @user.organisation_name = params[:user][:organisation_name]
        if @user.save
          flash[:info] = "Hurray! Company name is sucessfully modified"
        end
      end
    end
    redirect_to me_index_path
  end

  def update_organization
     @user = current_user
     @user.organisation_name = params[:user][:organisation_name]
        if @user.save
          flash[:info] = "Hurray! Company name is sucessfully modified"
        end
  end
  
  def edit
    
  end
  
end
