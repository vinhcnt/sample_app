class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.pagination
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "shared.user_not_found"
    redirect_to root_path
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "shared.welcome_to_the_sample_app"
      redirect_to @user
    else
      flash[:danger] = t "shared.error_sign_up"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "shared.profile_updated"
      redirect_to @user
    else
      flash[:danger] = t "shared.profile_update_failed"
      render :edit
    end
  end

  def destroy
    if User.find_by(id: params[:id])&.destroy
      flash[:success] = t "shared.user_deleted"
    else
      flash[:danger] = t "shared.user_not_found"
    end

    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "shared.please_log_in"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless @user == current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
