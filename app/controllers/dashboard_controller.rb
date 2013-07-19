class DashboardController < ApplicationController
  
  before_filter :signed_in?, :authenticate_user!
  
  def index
    logger = Logger.new('log/debug.log')
    logger.info('-----------Log for dashboard index--------------')
    yesterday = Time.now.end_of_day - 1.day
    
    tomorrow = Time.now.beginning_of_day + 1.day
    
    logger.info(yesterday.to_datetime)
    logger.info(tomorrow.to_datetime)
    
    get_visitors(yesterday.to_datetime, tomorrow.to_datetime, params[:page])
  end
  
  def view_options
    logger = Logger.new('log/debug.log')
    logger.info('-----------Log for Dashboard-------------')
    @view_option = params[:option_view]
    if (@view_option.nil? || @view_option.empty?)
      @view_option = session[:option_view]
    end
    
    if @view_option.nil?
      @view_option = "Daily"
    end
    
    if(params[:from].present? && params[:to].present?)
      logger.info('start: ' + params[:from])
      start = DateTime.strptime(params[:from], '%m/%d/%Y')
      end_t = DateTime.strptime(params[:to], '%m/%d/%Y')
    else
      session[:option_view] = @view_option
      case @view_option
      when 'Daily'
        start = Time.now.end_of_day - 1.day
        end_t = Time.now.beginning_of_day + 1.day
      when 'Weekly'
        start = Time.now.beginning_of_week
        end_t = Time.now.end_of_week
      when 'Monthly'
        start = Time.now.beginning_of_month
        end_t = Time.now.end_of_month
      when 'Year'
        start = Time.now.beginning_of_year
        end_t = Time.now.end_of_year
      end
    end
    
    get_visitors(start.to_datetime, end_t.to_datetime, params[:page])
    respond_to do |format|
      format.html {
        render "index"
      }
      format.js
      format.xls { 
        filename = "Visitors-#{Time.now.strftime("%Y%m%d%H%M%S")}.xls",
        send_data(@all_visitors.to_xls(
                  :only => [:id, :pass_id, :visitor_name,  :visitor_mobile_number,
                  :visitor_company_name, :check_out_time, :here_to_meet, :location, :status,
                  :badge_number, :user_location, :zip_code, :user_id],
                  :headers => ["id", "34passid", "Visitor name",  "mobile number",
                  "Organisation", "Check In", "Here to meet", "Location to visit", "Status",
                  "Badge ID", "Created by"]),
                  :filename => filename) 
                # :authorized_id, :comment, :here_to_meet, :location, :reason_to_visit, :storage_device_detail, :coming_from,
                 # :user_id, :visitor_company_name, :visitor_mobile_number, :visitor_name, :visitor_vehicle_number, :pass_id, 
                  #:photo, :check_out_time, :badge_number, :status
      }
      format.pdf {
        render :pdf => 'pdf', 
               :template => "dashboard/view_options.pdf.erb"
      }
    end
    
  end
  
  def view_mode
    @view_mode = params[:option_view]
  end
  
  private 
  
  def get_visitors(start, end_t, page)
    @all_visitors = Visitor.where('user_id = ? AND created_at >= ? AND created_at <= ?', current_user.id, start, end_t)
    @visitors = Visitor.where('user_id = ? AND created_at >= ? AND created_at <= ?', current_user.id, start, end_t).paginate(:per_page => 3, :page => page)
    #@unique_visitors = Visitor.where('user_id = ? AND created_at >= ? AND created_at <= ?', current_user.id, start, end_t).group_by('pass_id')
    @most_visitors = Visitor.select('visitor_name, visitor_mobile_number, count(visitor_name) as num_visitors').where('user_id = ?', current_user.id).group('visitor_name').group("visitor_mobile_number").order('num_visitors desc').limit(5)
    @here_to_meet = Visitor.select('here_to_meet').where('user_id = ?', current_user.id).group("here_to_meet").limit(5) 
    #Visitor.where('user_id = ?', current_user.id).group_by('pass_id').order_by('count(id)')
    twelve_ago = Time.now - 12.hours
    @expired = Visitor.where('(((created_at <= ?) AND (check_out_time is null))) AND (user_id = ?) AND created_at >= ? AND created_at <= ?', twelve_ago, current_user.id, start, end_t)
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
