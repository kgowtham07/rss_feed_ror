class CreateNewsHubs < ActiveRecord::Migration[5.2]
  def change
    create_table :news_hubs do |t|
      t.string :name
      t.string :url
      t.string :url_digest

      t.timestamps
    end
  end
end
