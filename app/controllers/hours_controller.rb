class HoursController < ApplicationController
  before_filter :login_required
#  skip_before_filter :verify_authenticity_token, :only => [:create]
#  skip_before_filter :login_required, :only => [:create]
  
  autocomplete :project, :name, :full => true
  
  def index
    @hours = Hour.all
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    respond_to do |format|
      format.html
      format.xml { render :xml => @hours}
    end
  end

  def show
    @hour = Hour.find(params[:id])
  end
  
  def show_xml
    @hours = Hour.all
    render :xml => @hours
  end
  

  def new
    @hour = Hour.new
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def create
    @hour = Hour.new(params[:hour])
    if @hour.save
      flash[:notice] = "New Time record created."
      redirect_to hours_url
    else
      render :action => 'new'
    end
  end

  def edit
    @hour = Hour.find(params[:id])
  end

  def update
    @hour = Hour.find(params[:id])
    if @hour.update_attributes(params[:hour])
      flash[:notice] = "Successfully updated time record."
      redirect_to hour_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @hour = Hour.find(params[:id])
    @hour.destroy
    flash[:notice] = "Successfully deleted time record."
    redirect_to hours_url
  end
end
