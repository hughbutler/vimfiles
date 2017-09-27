class WeekendsController < Weekends::CommonController

    # before_action :set_weekend, only: %w(closeout ledger process_candidates edit new show update destroy)
    skip_before_action :set_weekend, only: %w(index archived)

    def index

        @archived = current_community.weekends.previous.order('start_date desc')
    end

    def archived
        @weekends = current_community.weekends.previous.order('start_date desc')
    end

    def closeout
        @candidates = @weekend.attendees.candidate.pre_status('accepted').joins(:person).order('last_name, first_name')
        @team = @weekend.attendees.team.joins(:person).order('last_name, first_name')
    end

    def ledger
        @payments = @weekend.payments.team_fees.order( 'payments.created_at desc' ).includes(:person)
    end

    def process_candidates
        message     = params[:message]

        @weekend.process_candidates!( message ) # event.delay.process_candidates!( message )
        @weekend.close!

        redirect_to weekend_closeout_url(@weekend), notice: 'All candidates have been graduated to pescadores!'
    end

    def show
    end

    def new
        @weekend = current_community.weekends.new

        @eligible = current_community.people.members
        @eligible = @eligible.order('last_name asc, first_name asc')
        @eligible = @eligible.collect{ |e| ["#{e.last_name}, #{first_name}", e.id] }
    end

    def edit
        @eligible = current_community.people.members
        @eligible = @weekend.gender == 'male' ? @eligible.men : @eligible.women
        @eligible = @eligible.order('last_name asc, first_name asc')
        @eligible = @eligible.collect{ |e| ["#{e.try(:last_name)}, #{e.try(:first_name)}", e.id] }
    end

    def create
        @weekend = current_community.weekends.new(weekend_params)

        if @weekend.save
            redirect_to dashboard_path, notice: 'Saved successfully.'
            redirect_to weekend_url(@weekend)
        else
            render :new
        end
    end

    def update

        this_url = edit_weekend_url(@weekend)
        if params[:weekend][:closed].present?
            this_url = weekend_closeout_url( @weekend )
        end

        if @weekend.update(weekend_params)
            redirect_to this_url, :notice => 'Changes saved.'
        else
            render :edit
        end

    end

    def destroy
        @weekend.destroy

        redirect_to weekends_url, notice: :destroy
    end

    private

    def weekend_params
        params.require(:weekend).permit(:weekend_number, :start_date, :end_date,
            :location_name, :street, :city, :state_id,
            :postal, :coordinator_id, :community_id,
            :theme, :attendee_cost, :angel_cost, :gender,
        :verse, :closed, :step, :verse_reference)
    end

end
