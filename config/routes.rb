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
  
  #resources :users
  #リスト 14.15: Usersコントローラにfollowingアクションとfollowersアクションを追加する
  resources :users do
    member do
      #/users/:id/ ...
      get :following, :followers
      #GET /users/1/following -> following aciton
      #GET /users/1/followers -> followers aciton
    end
  end
  
  
  #リスト 11.1: アカウント有効化に使うリソース
  # GET "/account_activations/:id/edit"
  # params[:id] <--- 有効化トークン
  # Controller: params[:id]
  resources :account_activations, only: [:edit]
  
  
  #リスト 12.1: パスワード再設定用リソースを追加する
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
  #リスト 13.30: マイクロポストリソースのルーティング
  resources :microposts,          only: [:create, :destroy]
  
  #リスト 14.20: Relationshipリソース用のルーティングを追加する
  resources :relationships,       only: [:create, :destroy]
  
  # => contact_path
  
  #get 'static_pages/home'
  #get 'static_pages/help'
  #get 'static_pages/about'
  #get 'static_pages/contact'

  #root 'application#hello'
  #
  
  get 'to_japaness', to: 'static_pages#japaness'
  get 'to_english', to: 'static_pages#english'
  
end
