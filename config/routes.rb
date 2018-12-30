Rails.application.routes.draw do
  root 'static_page#home'
  
  get 'sessions/new'

  get '/signup',   to: 'users#new'
  get  '/help',    to: 'static_page#help'
  get  '/about',   to: 'static_page#about'
  get  '/contact', to: 'static_page#contact'
  post '/signup',  to: 'users#create'
  
  resources :users
  resources :microposts,  only: [:create, :destroy]
  resources :news_hubs,   only: [:edit, :update, :show, :destory]

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end