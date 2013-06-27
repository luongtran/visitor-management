class VisitorsController < ApplicationController
  
  before_filter :signed_in?
  PER_PAGE = 10
  
  before_filter :authenticate_user!
  before_filter :get_daily_visitors, :only => [:new, :create]
  
  # GET /visitors
  # GET /visitors.json
  def index
    @visitors = Visitor.get_visitors(current_user.id).paginate(:per_page => PER_PAGE, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @visitors }
    end
  end

  # GET /visitors/1
  # GET /visitors/1.json
  def show
    @visitor = Visitor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @visitor }
    end
  end

  # GET /visitors/new
  # GET /visitors/new.json
  def new
    @visitor = Visitor.new
      
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @visitor }
    end
  end

  # GET /visitors/1/edit
  def edit
    @visitor = Visitor.find(params[:id])
  end

  # POST /visitors
  # POST /visitors.json
  def create
    @visitor = Visitor.new(params[:visitor])
    @visitor.user_id = current_user.id
    @visitor.user_location = current_user.location
    @visitor.zip_code      = current_user.zip_code
    if FileTest.exist?(upload_path)
      @visitor.photo = File.new(upload_path)
    end
    
    respond_to do |format|
      if @visitor.save_with_out_print
        format.html { redirect_to new_visitor_path, notice: 'Visitor has checked in.' }
        format.json { render json: @visitor, status: :created, location: @visitor }
      else
        format.html { 
          #flash[:error] = Array.new
          i = 0
          @visitor.errors.full_messages.each do |er|
            flash["error" + i.to_s] = er
            i+=1
          end
          render action: "new" 
        }
        format.json { render json: @visitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /visitors/1
  # PUT /visitors/1.json
  def update
    @visitor = Visitor.find(params[:id])
    respond_to do |format|
      if @visitor.update_attributes(params[:visitor])
        format.html { redirect_to @visitor, notice: 'Visitor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @visitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visitors/1
  # DELETE /visitors/1.json
  
  def visitor_checkout
    logger = Logger.new('log/debug.log')
    logger.info('------Log for visitor checkout-----')
    if request.post?
      logger.info("log")
      if (!params[:pass_id].blank? && params[:badge_number].blank?)
         conditions = ['pass_id = ? AND user_id = ?', params[:pass_id], current_user.id]
      end
      
      if(!params[:badge_number].blank? && params[:pass_id].blank?)
        conditions = ['badge_number = ? AND user_id = ?', params[:badge_number], current_user.id]
      end
      
      if (!params[:pass_id].blank? && !params[:badge_number].blank?)
        conditions = ['badge_number = ? AND pass_id = ? AND user_id = ?', params[:badge_number], params[:pass_id], current_user.id]
      end
      
      logger.info(conditions.to_s)
      
      visitor = Visitor.find(:first, :conditions => conditions)
      
      @success = 0
      if !visitor.nil?
        logger.info('visitor not nil')
        if visitor.update_attributes(status: "Checked Out", check_out_time: Time.now)
          logger.info('check out successfully')
          @success = 1
          flash[:success] = 'The visitor ' + visitor.visitor_name + ' checked out successfully'
          message = flash[:success]
        else
          logger.info(visitor.errors.full_messages.join("\n"))
        end
      else
        logger.info("visitor nil")
        @success = 0
        flash[:error] = 'The visitor not found. Please check and try again'
        message = flash[:error]
      end
      
      respond_to do |format|
        format.json { render :json => {'success' => @success, 'id' => visitor.id, 'message' => message}}
        format.html
      end
      
    end
  end
  
  def search
    search_keyword = params[:search_keyword] if params[:search_keyword].present?
    if (!params[:search_key].nil? && !params[:search_key].empty?)
      key = params[:search_key]
      session[:search_key] = key
    else
      key = session[:search_key]
    end
    if search_keyword == "now_inside"
      @visitors = Visitor.insiders(current_user.id).paginate(:per_page => PER_PAGE, :page => params[:page])
    else
      puts "!" * 30
      puts "Am in Visitor Search controller"
      @visitors = Visitor.search(search_keyword, key, current_user.id).paginate(:per_page => PER_PAGE, :page => params[:page])
      puts "Visitors length: #{@visitors.length}"
      @visitors.each { |v| puts "Visitor: #{v.inspect}"}
      puts "!" * 30
    end
    respond_to do |format|
      format.js
      format.html
      format.json { render json: @visitors }
    end
  end
  
  def twelve_plus
    #logger = Logger.new('log/debug.log')
    #logger.info('---Log for twelve plus----')
    twelve_ago = Time.now - 12.hours
    #logger.info(twelve_ago)
    @visitors = Visitor.where('(created_at <= ?) AND (check_out_time is null) AND (user_id = ?)', twelve_ago, current_user.id).paginate(:per_page => PER_PAGE, :page => params[:page])
    @visitors.each {|v| v.update_attributes(status: "Expired")}
    render 'index'
  end
  
  def ajax_get_customer_by_phone
    @visitor = Visitor.find(:last, :conditions => ['visitor_mobile_number = ? AND user_id = ?', params[:visitor_mobile_number], current_user.id])
    if !@visitor.nil?
      @existed = 1
    else
      @existed = 0
    end
    render :json => {'existed' => @existed, 'visitor' => @visitor, 
                     'visitor_photo' => @visitor.photo.url}
  end
  
  private
  
  def get_daily_visitors
    visitors = Visitor.find(:all, :conditions => ['DATE(created_at) = DATE(?)', Time.now])
    @daily_visitors = visitors.length
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
