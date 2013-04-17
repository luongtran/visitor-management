class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout :layout_by_resource
  def layout_by_resource
    if user_signed_in?
      "application"
    else
      "loged_out"
    end
  end
  
  def after_sign_in_path_for(resource)
    flash[:notice] = nil
    new_visitor_path
  end
  
end
