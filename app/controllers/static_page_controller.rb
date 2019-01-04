class StaticPageController < ApplicationController
  
  def home
    if logged_in? && admin_user?
      redirect_to showhub_path
    end
    if logged_in?
      @news_hubs = current_user.news_hubs
      @newsfeed = Array.new
      @news_hubs.each do |hub_source|
        hub_source.news_feeds.order('published_on DESC').limit(5).each do |feed|
          @newsfeed<<feed
        end
      end
      sorted = @newsfeed.sort_by {|news_feed| news_feed.published_on}.reverse
      @feed_items = sorted.paginate(page: params[:page], per_page: 10)
    end
  end

  def help
  end

  def about
  end
end