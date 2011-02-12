class Admin::EmailsController < AdminController
  helper_method :sort_column, :sort_direction
  
  def index
    @emails = EmailTemplate.perform_search(params[:search], sort_column, sort_direction)
  end
  
  def edit
    @email = EmailTemplate.find(params[:id])
  end
  
  def update
    @email = EmailTemplate.find(params[:id])

    if @email.update_attributes(params[:email_template])
      flash[:notice] = "Successfully updated email template"
      redirect_to admin_emails_url
    else
      flash[:error] = "Unable to update email template"
      render :action => 'edit'
    end
  end
  
  def show
    @email = EmailTemplate.find(params[:id])
  end
  
  private
    def sort_column
      EmailTemplate.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
