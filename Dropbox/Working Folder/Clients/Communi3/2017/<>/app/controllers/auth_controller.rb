class AuthController < ApplicationController

before_action :force_sign_in if Rails.env.development?
  before_action :authenticate_user!
  before_action :current_community

  def force_sign_in
    @user = User.first
    sign_in @user
  end
  helper_method :current_user

  def current_community community_id = nil

    if user_signed_in?
      @current_community ||= current_user.try(:community)
      session[:community_id] ||= @current_community.id
      return @current_community
    end

  end
  helper_method :current_community

  private

  # def current_user
  #   @current_user = current_user
  # end
  # helper_method :current_user

  # def authenticate_user!
  #   redirect_to root_url unless company_admin_signed_in?
  # end

end

