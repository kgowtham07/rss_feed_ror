class SourceSubscription < ApplicationRecord
  belongs_to :news_hub
  belongs_to :user

  def source_list
    subscription_id_list = SourceSubscription.find_by(user_id: session[:user_id])
  end
  
end
