class LoginsController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :role_summary_data

  def create
    @user = User.new(:person_id => params[:person_id], :email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation])
    if @user.save
      redirect_to person_url(@user.person_id), :notice => 'User login created!'
    else
      redirect_to person_url(@user.person_id), :notice => 'User login could not be created.'
    end
  end

  def update
      @user = User.find(params[:id])
      @user.email = params[:email]
      if params[:change_password].to_s == 'true' and params[:password].present? and params[:password].to_s == params[:password_confirmation].to_s
        @user.password = params[:password]
        @user.password_confirmation = params[:password_confirmation]
      end
      if @user.save
        redirect_to person_url(@user.person_id), :notice => "The password has been updated to \"#{params[:password]}\"."
      else
        redirect_to person_url(@user.person_id), :notice => 'User login could not be updated at this time.'
      end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to person_url(@user.person_id), :notice => 'Login information has been removed.'
  end
end
