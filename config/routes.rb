Rails.application.routes.draw do
  get 'sessions/new'
  get '/signup',   to: 'users#new'
  root 'static_page#home'
  get  '/help',    to: 'static_page#help'
  get  '/about',   to: 'static_page#about'
  get  '/contact', to: 'static_page#contact'
  post '/signup',  to: 'users#create'
  
  resources :users

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
