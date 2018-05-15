Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  #get 'users/new'

  root 'static_pages#home' # => root_path
  
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  resources :users
  
  
  #リスト 11.1: アカウント有効化に使うリソース
  # GET "/account_activations/:id/edit"
  # params[:id] <--- 有効化トークン
  # Controller: params[:id]
  resources :account_activations, only: [:edit]
  
  
  #リスト 12.1: パスワード再設定用リソースを追加する
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
  #リスト 13.30: マイクロポストリソースのルーティング
  resources :microposts,          only: [:create, :destroy]
  
  # => contact_path
  
  #get 'static_pages/home'
  #get 'static_pages/help'
  #get 'static_pages/about'
  #get 'static_pages/contact'

  #root 'application#hello'
  #
  
  
end
