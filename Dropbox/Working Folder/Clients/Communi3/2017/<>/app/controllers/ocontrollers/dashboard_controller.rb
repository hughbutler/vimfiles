class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    @nominations = current_user.nominations.where(:is_accepted => false)
    @candidates = current_user.person.children
  end

end
