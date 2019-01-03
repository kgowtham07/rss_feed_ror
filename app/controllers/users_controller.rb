class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,:show_source, :toggle_subscribe, :toggle_read]
  before_action :correct_user,   only: [:edit, :update]
  #before_action :admin_user,     only: :destroy


  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      flash[:danger] = "Sorry, couldn't create account. Please try again."
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def show_source
    @news_hub = NewsHub.paginate(page: params[:page])
  end
  

  def toggle_subscribe
    @news_hub = NewsHub.find(params[:news_hub_id])
    
    if !current_user.following?(@news_hub)
      current_user.follow(@news_hub)
    elsif current_user.following?(@news_hub)
      current_user.stop_following(@news_hub)
    end

    respond_to do |format|
      format.html { redirect_to source_path }
      # format.js {render :nothing => true}
    end
  end

  def toggle_read
    @news_feed = NewsFeed.find(params[:news_feed_id])

    if !current_user.have_read?(@news_feed)
      @news_feed.mark_as_read! for: current_user
    end

    respond_to do |format|
      format.html { render root_url }
      format.js {render :nothing => true}
    end
  end

 

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)    
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
