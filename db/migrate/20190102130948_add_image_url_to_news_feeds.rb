class AddImageUrlToNewsFeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :news_feeds, :image_url, :string
  end
end
