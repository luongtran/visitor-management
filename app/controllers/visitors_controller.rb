class VisitorsController < ApplicationController
  
  PER_PAGE = 5
  
  before_filter :authenticate_user!
  
  # GET /visitors
  # GET /visitors.json
  def index
    @visitors = Visitor.get_visitors(current_user.id).paginate(:per_page => 3, :page => params[:page])

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
    @visitor.photo = File.new(upload_path)

    respond_to do |format|
      if @visitor.save
        format.html { redirect_to @visitor, notice: 'Visitor was successfully created.' }
        format.json { render json: @visitor, status: :created, location: @visitor }
      else
        format.html { render action: "new" }
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
      visitor = Visitor.find(:first, :conditions => ['pass_id = ?', params[:pass_id]])
      @success = 0
      if !visitor.nil?
        visitor.check_out_time = Time.now
        if visitor.save
          @success = 1
        end
      end
      if @success
        flash[:notice] = 'The visitor ' + visitor.visitor_name + ' checked out successfully'
      else
        flash[:notice] = 'The visitor ' + visitor.visitor_name + ' checked out unsuccessfully. Please check and try again'
      end
      if request.xhr?
        render :json => {'success' => @success, 'id' => visitor.id, 'message' => flash[:notice]}
        return
      end
      
    end
  end
  
  def search
    key = params[:search_key]
    @visitors = Visitor.search(key, current_user.id).paginate(:per_page => 3, :page => params[:page])
    
    respond_to do |format|
      format.js
      format.html {
        render 'index' 
      }
      format.json { render json: @visitors }
    end
     
  end
  
  def twelve_plus
    @visitors = Visitor.where('(created_at <= NOW() - INTERVAL 12 HOUR) AND check_out_time is null').paginate(:per_page => 3, :page => params[:page])
    render 'index'
  end
  
  private
  
  def upload_path # is used in upload and create
    file_name = session[:session_id].to_s + '.jpg'
    File.join(Rails.root, 'public', 'uploads', file_name)
  end
  
end
