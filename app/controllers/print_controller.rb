class PrintController < ApplicationController
  layout "print_page"
  
  #POST /visitors/save-print
  def save_and_print
    
    @visitor = Visitor.new(params[:visitor])
    @visitor.user_id = current_user.id
    if FileTest.exist?(upload_path)
      @visitor.photo = File.new(upload_path)
    end
    respond_to do |format|
      if @visitor.save_print
        format.html 
      else
        format.html {
          i = 0
          @visitor.errors.full_messages.each do |er|
            flash["error" + i.to_s] = er
            i+=1
          end
          redirect_to new_visitor_path
        }
      end
    end
  end
end
