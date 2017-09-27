class Settings::MailTemplatesController < Settings::AuthController
  before_action :set_mail_template, only: [:show, :edit, :update, :destroy]

  def index
    @mail_templates = current_community.mail_templates
  end

  def deliver
    message = mail_template_params
    to      = "#{params[:to][:name]} <#{params[:to][:address]}>"
    from    = "#{params[:from][:name]} <#{message[:from_address] || current_user.person.email}>"

    @mail_template = message[:id].present? ? current_community.mail_templates.find(message[:id]) : current_community.mail_templates.new( from_address: current_user.email )
    @mail_template.update(message) if params[:save].present?

      # return render text: from
      Internal.communication(to, message[:subject], message[:blurb], from, current_user.person.community).deliver_later

      respond_to do |format|
        format.js { render :json => @mail_template }
      end

    end

    def find_by_context
      @mail_template = current_community.mail_templates.find_by_context(params[:context]) || current_community.mail_templates.new( from_address: current_user.email )
      respond_to do |format|
        format.js { render :json => @mail_template }
      end
    end

    def edit
    end

    def update

      respond_to do |format|
        if @mail_template.update(mail_template_params)
          format.html { redirect_to(settings_mail_templates_url, :notice => 'Saved changes') }
        else
          format.html { render :action => "edit" }
        end
      end
    end

    private

      def set_mail_template
        @mail_template = current_community.mail_templates.find(params[:id])
      end

      def mail_template_params
        params.require(:mail_template).permit(:blurb,
                                              :context,
                                              :subject,
                                              :from_address)
      end

end
