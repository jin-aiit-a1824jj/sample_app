Rails.application.routes.draw do

  #get 'users/new'

  root 'static_pages#home' # => root_path
  
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  
  resources :users
  
  # => contact_path
  
  #get 'static_pages/home'
  #get 'static_pages/help'
  #get 'static_pages/about'
  #get 'static_pages/contact'

  #root 'application#hello'
  #
  
end
