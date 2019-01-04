class CreateViewStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :view_statuses do |t|
      t.references :user, foreign_key: true
      t.references :news_feed, foreign_key: true

      t.timestamps
    end
  end
end
