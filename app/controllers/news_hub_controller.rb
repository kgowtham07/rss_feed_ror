class NewsHubController < ApplicationController

    before_action :logged_in_user
    before_action :admin_user,     only: [:index, :destroy, :edit, :update]

    def index
        @news_hub = NewsHub.paginate(page: params[:page])
    end

    def new
        @news_hub = NewsHub.new
    end

    def create
        @news_hub = NewsHub.new(params[:news_hub])
        if @news_hub.save
          log_in @news_hub
          flash[:success] = "Successfully Added #{@news_hub.name}"
          redirect_to @news_hub
        else
          flash[:danger] = "Sorry, couldn't add the source. Please try again."
          render 'new'
        end
    end

    def show
        @news_hub = NewsHub.find(params[:id])
        @news_feed = @news_hub.news_feed.paginate(page: params[:page])
    end

    def show_all
        @news_hub = NewsHub.all
        # Add pagination by adding all the news article from different sources
    end
    
    def destroy
        NewsHub.find(params[:id]).destroy
        flash[:success] = "News Source deleted"
        redirect_to newshub_url
    end

    private
        def admin_user
            redirect_to(root_url) unless current_user.admin?
        end
end
