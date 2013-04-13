class VisitorsController < ApplicationController
  
  PER_PAGE = 5
  
  before_filter :authenticate_user!, :except => :created
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
    if FileTest.exist?(upload_path)
      @visitor.photo = File.new(upload_path)
    end
    
    respond_to do |format|
      if @visitor.save
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
  def destroy
    @visitor = Visitor.find(params[:id])
    @visitor.destroy

    respond_to do |format|
      format.html { redirect_to visitors_url }
      format.json { head :no_content }
    end
  end
  
  def visitor_checkout
    if request.post?
      visitor = Visitor.find(:first, :conditions => ['pass_id = ? OR badge_number = ?', params[:pass_id], params[:badge_number]])
      @success = 0
      if !visitor.nil?
        visitor.check_out_time = Time.now
        if visitor.save
          @success = 1
        end
      end
      
      if @success
        flash[:success] = 'The visitor ' + visitor.visitor_name + ' checked out successfully'
        message = flash[:success]
      else
        flash[:error] = 'The visitor ' + visitor.visitor_name + ' checked out unsuccessfully. Please check and try again'
        message = flash[:error]
      end
      
      respond_to do |format|
        format.json { render :json => {'success' => @success, 'id' => visitor.id, 'message' => message}}
        format.html
      end
      
    end
  end
  
  def search
    if (!params[:search_key].nil? && !params[:search_key].empty?)
       key = params[:search_key]
      @visitors = Visitor.search(key, current_user.id).paginate(:per_page => 3, :page => params[:page])
      
      respond_to do |format|
        format.js
        format.html
        format.json { render json: @visitors }
      end
    end
    
  end
  
  def twelve_plus
    #logger = Logger.new('log/debug.log')
    #logger.info('---Log for twelve plus----')
    twelve_ago = Time.now - 12.hours
    #logger.info(twelve_ago)
    @visitors = Visitor.where('(created_at <= ?) AND check_out_time is null', twelve_ago).paginate(:per_page => 3, :page => params[:page])
    render 'index'
  end
  
  private
  
  def upload_path # is used in upload and create
    file_name = session[:session_id].to_s + '.jpg'
    File.join(Rails.root, 'public', 'uploads', file_name)
  end
  
  def get_daily_visitors
    visitors = Visitor.find(:all, :conditions => ['DATE(created_at) = DATE(?)', Time.now])
    @daily_visitors = visitors.length
  end
  
end
