class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :load_user, only: %i(show following followers)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.pagination
  end

  def new
    @user = User.new
  end

  def show
    @microposts = @user.microposts.created_post_at.page(params[:page]).per Settings.micropost.pagination
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:success] = t ".welcome_to_the_sample_app"
      redirect_to @user
    else
      flash[:danger] = t ".error_sign_up"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      flash[:danger] = t ".profile_update_failed"
      render :edit
    end
  end

  def destroy
    if User.find_by(id: params[:id])&.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".user_not_found"
    end

    redirect_to users_url
  end

  def following
    @title = t ".title"
    @users = @user.following.page params[:page]
    render "show_follow"
  end

  def followers
    @title = t ".title"
    @users = @user.followers.page params[:page]
    render "show_follow"
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "user_not_found"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless @user == current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
