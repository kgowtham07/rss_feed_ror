namespace :news_hub do
  desc "TODO"
  task fetch_article: :environment do
    news_hub = NewsHub.new
    news_hub.articlePoller
  end

  task add_source: :environment do
    User.create!(name:  "admin",
      email: "admin@newsfeed.org",
      password:              "admin123",
      password_confirmation: "admin123",
      admin: true)
  end

end
