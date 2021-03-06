class User < ApplicationRecord
  
  acts_as_reader

  has_many :microposts, dependent: :destroy
  has_many :source_subscriptions, dependent: :destroy
  has_many :news_hubs, through: :source_subscriptions
  has_many :view_status, dependent: :destroy
  has_many :news_feeds, through: :view_status

  before_save { self.email = email.downcase }
  attr_accessor :remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def following?(news_hub)
    news_hubs.include?(news_hub)
  end
  
  def follow(news_hub)
    news_hubs << news_hub
  end

  def stop_following(news_hub)
    news_hubs.delete(news_hub)
  end

  def followings
    news_hubs
  end
  
  def viewed?(news_feed)
    news_feeds.include?(news_feed)
  end
  
  def mark_viewed(news_feed)
    news_feeds << news_feed
  end
  
  

  # Defines a proto-feed.
  # See "Following users" for the full implementation.
  def feed
    Micropost.where("user_id = ?", id)
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

end