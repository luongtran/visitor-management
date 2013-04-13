class DashboardController < ApplicationController
  
  before_filter :authenticate_user!
  
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
    
    if(!params[:from].nil? && !params[:to].nil?)
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
    render 'index'
  end
  
  def view_mode
    @view_mode = params[:option_view]
  end
  
  
  private 
  
  def get_visitors(start, end_t, page)
    @all_visitors = Visitor.where('user_id = ? AND created_at >= ? AND created_at <= ?', current_user.id, start, end_t)
    @visitors = Visitor.where('user_id = ? AND created_at >= ? AND created_at <= ?', current_user.id, start, end_t).paginate(:per_page => 3, :page => page)
    #@unique_visitors = Visitor.where('user_id = ? AND created_at >= ? AND created_at <= ?', current_user.id, start, end_t).group_by('pass_id')
    @most_visitors = Visitor.select('visitor_name, visitor_mobile_number, count(visitor_name) as num_visitors').where('user_id = ?', current_user.id).group('visitor_name').group('visitor_mobile_number').order('count(visitor_name)').limit(5) #Visitor.where('user_id = ?', current_user.id).group_by('pass_id').order_by('count(id)')
  end
  
end
