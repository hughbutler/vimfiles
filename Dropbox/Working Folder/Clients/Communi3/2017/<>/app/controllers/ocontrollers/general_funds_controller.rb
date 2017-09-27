class GeneralFundsController < InheritedResources::Base
  before_filter :authenticate_user!

  def index
    @event = Event.find(params[:event_id])
    @general_funds = @event.general_funds.order( 'general_funds.created_at desc' )
    @current_page = 'weekends top_general_funds'
  end

  def destroy
    GeneralFund.find(params[:id]).destroy
    respond_to do |format|
      format.js
    end
  end
end
