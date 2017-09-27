class Weekends::PaymentsController < Weekends::CommonController
    before_filter :set_attendee_and_person

    include ActionView::Helpers::NumberHelper

    # def new
    #   @payment = Payment.new
    #   @redirect_to = params[:redirect_to]
    #   @attendance = current_user.person.is_scheduled_for_next_weekend?
    #   # @dues_remaining = @attendance.remaining_fees
    #   redirect_to dashboard_url, notice: 'You are not scheduled for a weekend.' if @attendance.nil?
    # end

    def create
        p = allowed_params

        payment = @weekend.payments.new(allowed_params)

        # @event = Event.find(p[:event_id])
        # @payment = Payment.new( :community_id => @event.community_id, :person_id => p[:person_id], :event_id => p[:event_id], :payment_type => p[:payment_type], :amount => p[:amount], :note => p[:note] )
        bounceback_url = p[:url] || dashboard_path

        # donating money
        if payment.is_donation?
            @weekend.general_funds.create(
                person_id: payment.person_id,
                note: payment.note,
                amount: payment.amount
            )
        end

        # paying out of general fund
        # if p[:applying_funds].present?
        #     GeneralFund.create( :event_id => @payment.event_id, :person_id => @payment.person_id, :amount => -(@payment.amount) )
        # end

        respond_to do |format|
            if payment.save
                # @person = Person.find(@payment.person_id)
                # @team_fees = @person.total_fees_paid(@payment.event_id)
                # @financial_assistance = @person.financial_assistance(@payment.event_id)
                # @donation_payments = @person.total_donations(@payment.event_id)
                # @total_payments = @person.total_payments(@payment.event_id)

                # format.js { render :json => [@team_fees, @financial_assistance, @total_payments, @donation_payments] }
                format.js {}
                format.html { redirect_to( bounceback_url, :notice => 'Payment has been added.') }
            else
                format.js
                format.html { render :action => "new" }
                format.xml  { render :xml => payment.errors, :status => :unprocessable_entity }
            end
        end
    end

    def pay_online
        Stripe.api_key = "sk_live_5lWFufg6dOEiMm7H68M7oPNV"
        # Stripe.api_key = "sk_test_jyvFWzDOC09potjZGV6NWJeA"

        # get the credit card details submitted by the form
        token = params[:stripeToken]

        @payment = Payment.new(params[:payment])
        @payment.note = "Made payment online"

        # amount to charge
        amount = ( @payment.amount * 100 ).to_i

        respond_to do |format|
            if @payment.save

                # create the charge on Stripe's servers - this will charge the user's card
                charge = Stripe::Charge.create(
                    :amount => amount,
                    :currency => "usd",
                    :card => token,
                    :description => "#{@payment.person.first_name} #{@payment.person.last_name} team fees for #{@payment.event.title} (PaymentID: #{@payment.id})"
                )

                @payment.update_attribute('token', charge.id)

                bounceback = params[:redirect_to] || dashboard_url
                format.html { redirect_to( bounceback, :notice => "Your card has been charged #{number_to_currency @payment.amount} and applied to your Team Fees." ) }
            else
                @attendance = current_user.person.is_scheduled_for_next_weekend?
                return render text: @payment.inspect
                format.html { render :action => 'new' }
            end
        end
    end

    def update
        @payment = Payment.find(params[:id])
        @payment.update_attributes(params[:payment])
    end

    def destroy
        @payment = Payment.find(params[:id])
        @payment.destroy
    end

    private

    def set_attendee_and_person
        @attendee = @weekend.attendees.where(person_id: allowed_params[:person_id]).take
        # @person = @attendee.person
    end

    def allowed_params
        params.require(:weekend_payment).permit(
            :person_id, :weekend_id,
            :payment_type, :amount,
            :deleted, :note, :source,
            :token
        )
    end


end
