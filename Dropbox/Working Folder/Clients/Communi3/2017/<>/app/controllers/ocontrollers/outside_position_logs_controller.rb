class OutsidePositionLogsController < ApplicationController
  before_filter :authenticate_user!
  # GET /outside_position_logs
  # GET /outside_position_logs.xml
  def index
    @outside_position_logs = OutsidePositionLog.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @outside_position_logs }
    end
  end

  # POST /outside_position_logs
  # POST /outside_position_logs.xml
  def create
    @outside_position_log = OutsidePositionLog.new(params[:outside_position_log])

    respond_to do |format|
      if @outside_position_log.save
        format.html { redirect_to(@outside_position_log, :notice => 'Outside position log was successfully created.') }
        format.xml  { render :xml => @outside_position_log, :status => :created, :location => @outside_position_log }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @outside_position_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def bulk_create
    logs = OutsidePositionLog.find_by_person_id(params[:person_id])
    logs.destroy if logs.present?
    
    self.sanitize(params[:logs]).each do |log|
      OutsidePositionLog.create(:person_id => params[:person_id], :weekend => log[:weekend], :community => log[:community], :position_id => log[:position] )
    end
    
    flash[:notice] = "History has been updated!"
    redirect_to person_path(params[:person_id])    
  end

  def sanitize(logs)
    logs.delete_if { |log| log[:weekend].empty? }
    logs
  end

end
