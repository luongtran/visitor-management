class HereToMeetController < ApplicationController

	def show
		#@list = HereToMeet.find(params[:id]f, :limit => 5)
		@list = HereToMeet.where('organization = ? AND name LIKE ?',
			    current_user.organisation_name, '%' + params[:id] + '%').limit(5)

		respond_to do |format|
			format.json { render :json => @list }
		end
	end

end
