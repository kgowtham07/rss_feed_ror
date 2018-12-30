class NewsHub < ApplicationRecord
    validates :name, presence: true
    validates :url, presence: true
    validates :url_digest, presence: true

    has_many :news_feeds, class_name: "news_feed"

    def articlePoller
        sources = NewsHub.all
        if !sources.empty?
            sources.each do |source|
                feed = Feedjira::Feed.fetch_and_parse source.url
                # Check for using build inplace of new.
                feed.entries.each do |entry|
                    url_digest = Digest::SHA256.base64digest entry.url
                    if !NewsFeed.find_by(url_digest: url_digest)
                        news_feed_item = NewsFeed.new(title: "#{entry.title}",url: "#{entry.url}",
                            url_digest: "#{url_digest}",description:"#{entry.description}", 
                            published_on: "#{entry.published_on}",news_hub:"#{source.id}")
                        if !news_feed_item.save
                            puts "Failed to Enter the article #{entry.title} -- #{entry.url}"
                        end
                    end
                    
                end
                 
            end
        else
            puts "It's Working!!!"
        end
        
    end


end
