class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      user_authenticated_handle user
    else
      flash.now[:danger] = t ".invalid_email_password"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def user_authenticated_handle user
    if user.activated?
      log_in user
      params[:session][:remember_me] == Settings.checkbox ? remember(user) : forget(user)
      redirect_back_or user
    else
      message = t ".account_not_activated"
      flash[:warning] = message
      redirect_to root_url
    end
  end
end
