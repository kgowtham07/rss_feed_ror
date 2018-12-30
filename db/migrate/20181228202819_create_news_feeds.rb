class CreateNewsFeeds < ActiveRecord::Migration[5.2]
  def change
    create_table :news_feeds do |t|
      t.string :title
      t.string :url
      t.string :url_digest
      t.string :description
      t.timestamp :published_on
      t.references :news_hub, foreign_key: true

      t.timestamps
    end
  end
end
