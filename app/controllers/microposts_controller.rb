class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params[:micropost][:image]
    save_micropost
  end

  def destroy
    @micropost.destroy
    flash[:success] = t ".micropost_deleted"
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::PARAMS
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url unless @micropost
  end

  def save_micropost
    if @micropost.save
      flash[:success] = t ".micropost_created"
      redirect_to root_url
    else
      flash[:success] = t ".micropost_failed"
      @feed_items = current_user.feed.page params[:page]
      render "static_pages/home"
    end
  end
end
