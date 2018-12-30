class NewsFeed < ApplicationRecord
  belongs_to :news_hub
  validates :news_hub_id, presence: true
end
