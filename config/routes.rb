Rails.application.routes.draw do
  root 'static_page#home'
  
  get 'sessions/new'

  get  '/help',    to: 'static_page#help'
  get  '/about',   to: 'static_page#about'
  get  '/contact', to: 'static_page#contact'
  get '/signup',   to: 'users#new'
  post '/signup',  to: 'users#create'
  get '/source',  to: 'users#show_source'
  put '/source', to: 'users#toggle_subscribe'

  
  resources :users
  resources :microposts,  only: [:create, :destroy]
  resources :news_hubs
  resources :source_subscriptions, only: [:create, :destory]

  get '/addhub', to: 'news_hubs#new'
  get '/showhub', to: 'news_hubs#index'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end