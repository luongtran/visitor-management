class AdminController < ApplicationController

	before_filter :admin?

	def index
		@users = User.where('email LIKE ?', params[:email]) if params[:email]
	end

	def activate
		user = User.find(params[:id])
		user.expires = user.expires + 1.month.to_i
		if user.save
			flash[:success] = "User activated for 1 month"
			UserMailer.activated_message(user).deliver
			render :index
		else
			flash[:alert] = "Arror happend while activating"
			render :index
		end
	end

	private

	def admin?
		if !(current_user && current_user.admin) 
			redirect_to root_path
		end
	end
end
