class MailTemplatesController < ApplicationController
    before_filter lambda { current_page 'settings' }

    def index
      @mail_templates = MailTemplate.by_community(community_id)
      @current_page+= ' top_mail_templates'
    end

    def deliver
      message = params[:mail_template]
      to      = "#{params[:to][:name]} <#{params[:to][:address]}>"
      from    = "#{params[:from][:name]} <#{message[:from_address] || current_user.person.email}>"

      @mail_template = message[:id].present? ? MailTemplate.find(message[:id]) : MailTemplate.new( from_address: current_user.email )
      @mail_template.update_attributes(message) if params[:save].present?

      # return render text: from
      Internal.communication(to, message[:subject], message[:blurb], from, current_user.person.community).deliver

      respond_to do |format|
        format.js { render :json => @mail_template }
      end

    end

    def show
      @mail_templates = MailTemplate.find(params[:id])
    end

    def find_by_context
      @mail_template = MailTemplate.find_by_context(params[:context]) || MailTemplate.new( from_address: current_user.email )
      respond_to do |format|
        format.js { render :json => @mail_template }
      end
    end

    def edit
      @mail_template = MailTemplate.find(params[:id])
    end

    def update
      @mail_template = MailTemplate.find(params[:id])

      respond_to do |format|
        if @mail_template.update_attributes(params[:mail_template])
          format.html { redirect_to(mail_templates_url, :notice => 'Template was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @mail_template.errors, :status => :unprocessable_entity }
        end
      end
    end

    private

    def set_section
      @current_page = 'settings'
    end

end
