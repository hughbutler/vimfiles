require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :null_session

  def metas
    @metas ||= {
      title: 'Communi3'
    }
  end
  helper_method :metas

end
