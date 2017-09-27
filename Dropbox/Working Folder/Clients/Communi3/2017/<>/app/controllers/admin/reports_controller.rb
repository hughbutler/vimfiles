class Admin::ReportsController < Admin::AuthController
  helper_method :sort_column, :sort_direction
  # before_action -> { set_section('reports') }

  def transactions

    if params[:searching]
      # @appointments = Appointment.search(params).order(sort_joined(:appointment))
      # binding.remote_pry
      @franchises = Franchise.sum_transactions(params)
    else
      @franchises = []
    end

    respond_to do |format|
      format.html
    end

  end

private

  def sort_column(type)
    case type

    when :appointment
      Appointment.column_names.include?(params[:sort]) ? [params[:sort]] : ["start_at"]

    when :giftcard
      Giftcard.column_names.include?(params[:sort]) ? [params[:sort]] : ["giftcards.created_at"]

    when :ledger_entry
      case params[:sort]

      when 'customer'
        [ 'users.last_name', 'users.first_name' ]

      when 'service_history'
        [ 'appointments.start_at' ]

      when 'type'
        [ 'source_type', 'giftcards.campaign_id', 'giftcards.admin_id' ]

      else
        LedgerEntry.column_names.include?(params[:sort]) ? [params[:sort]] : ["ledger_entries.created_at"]

      end


    end
  end

  def sort_direction(type = nil)
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def sort_joined(type)
    columns = []
    sort_column(type).collect do |col|
      columns << col + " " + sort_direction(type)
    end

    columns.join(', ')
  end
end

