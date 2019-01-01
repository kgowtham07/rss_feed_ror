class NewsHubsController < ApplicationController

    before_action :logged_in_user
    before_action :admin_user,     only: [:index, :create, :destroy, :edit, :update]

    def index
        @news_hub = NewsHub.paginate(page: params[:page])
    end

    def new
        @news_hub = NewsHub.new
    end

    def create
        begin
            Feedjira::Feed.fetch_and_parse params[:news_hub][:url]
        rescue => exception
            flash[:danger] = "Sorry, invalid Feed. Please try again."
            redirect_to addhub_path
            return
        end        
        
        source_update = news_hub_params
        url_digest = Digest::SHA256.base64digest params[:news_hub][:url]
        # byebug
        source_update[:url_digest] = url_digest
        if !NewsHub.find_by(url_digest: url_digest)
            @news_hub = NewsHub.new(source_update)
            if @news_hub.save
                news_poller = NewsHub.new
                news_poller.articlePoller
            flash[:success] = "Successfully Added #{@news_hub.name}"
            redirect_to @news_hub
            else
            flash[:danger] = "Sorry, couldn't add the source. Please try again."
            render 'new'
            end
        else
            flash[:danger] = "Sorry, Hub Already exists!"
            render 'new'
        end
    end

    def show
        @news_hub = NewsHub.find(params[:id])
        @news_feed = @news_hub.news_feed.paginate(page: params[:page])
    end

    def edit
        @news_hub = NewsHub.find(params[:id])
    end
    
    def update

        begin
            Feedjira::Feed.fetch_and_parse params[:news_hub][:url]
        rescue => exception
            flash[:danger] = "Sorry, invalid edit. Please try again."
            redirect_to showhub_path
            return
        end

        @news_hub = NewsHub.find(params[:id])
        source_update = news_hub_params
        url_digest = Digest::SHA256.base64digest params[:news_hub][:url]
        source_update[:url_digest] = url_digest
        # byebug
        if @news_hub.update_attributes(source_update)
            news_poller = NewsHub.new
            news_poller.articlePoller
            flash[:success] = "Hub Updated"
            redirect_to @news_hub
        else
            flash[:danger] = "Something Went Wrong. Try again Later."
            render 'edit'
        end
    end
    
    def destroy
        NewsHub.find(params[:id]).destroy
        flash[:success] = "News Source deleted"
        redirect_to newshub_url
    end

    def show_all
        @news_hub = NewsHub.all
        # Add pagination by adding all the news article from different sources
    end

    private
        def admin_user
            redirect_to(root_url) unless current_user.admin?
        end

        def news_hub_params
            params.require(:news_hub).permit(:name, :url)
        end
end
