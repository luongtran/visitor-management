class PhotosController < ApplicationController
  
  before_filter :signed_in?, :authenticate_user!, :only => :index
  
  def create
    @photo = Photo.new(params[:photo])
    @photo.image = File.new(upload_path)
    @photo.save

    redirect_to @photo
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def index
    @photos = Photo.all
  end

  def upload
    File.open(upload_path, 'wb') do |f|
      f.write request.raw_post
    end
    render :text => "ok"
  end

  private

  def upload_path # is used in upload and create
    file_name = session[:session_id].to_s + '.jpg'
    File.join(Rails.root, 'public', 'uploads', file_name)
  end

  def signed_in?
    signed_in = user_signed_in? ? true : false
    render :template => 'welcome/index' unless user_not_expired?
  end

   def user_not_expired?
    if current_user
      redirect_to 'https://ch.eckout.com/secure/34pass1' unless (current_user.admin || (current_user.expires > Time.now)) 
      current_user
    end
  end
end
