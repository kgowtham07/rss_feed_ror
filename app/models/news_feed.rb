class NewsFeed < ApplicationRecord
  belongs_to :news_hub
  validates :news_hub_id, presence: true

  acts_as_readable on: :updated_at
end
