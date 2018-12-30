class CreateSourceSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :source_subscriptions do |t|
      t.references :news_hub, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
