class ChangeNewsFeedsUrl < ActiveRecord::Migration[5.2]
  def change
    change_column :news_feeds, :url, :text
  end
end
