class NewsFeed < ApplicationRecord
  belongs_to :news_hub
  validates :news_hub_id, presence: true

  has_many :view_status, dependent: :destroy
  has_many :users, through: :view_status

  acts_as_readable on: :created_at

  def self.mark_as_unread user
    ReadMark.where(readable_type: self.class.class_name, readable_id: id, reader_id: user.id).each(&:destroy!)
  end

end
