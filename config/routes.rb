Rails.application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'
  captcha_route
  require 'api_v1'
  root 'home#index'
    
  get '/help'  => 'home#help', as: :help
  get '/about' => 'home#about', as: :about
  get '/order_help' => 'home#order_help', as: :order_help
  get '/pay_help' => 'home#pay_help', as: :pay_help
  get '/deliver_help' => 'home#deliver_help', as: :deliver_help

  devise_for :users, path: "account", controllers: {
    registrations: :account,
    sessions: :sessions,
  }
  post "account/update_private_token" => "users#update_private_token", as: 'update_private_token_account'
  
  resources :users, only: [:update]
  resources :messages, only: [:new, :create]
  
  resources :likes
  resources :pages, path: "p", only: [:show]
  
  resource :user do
    get :home
    get :orders
    get :edit
    get :points
    get :likes
    
    get '/orders/incompleted', as: :incompleted_orders
    get '/orders/completed'  , as: :completed_orders
    get '/orders/canceled'   , as: :canceled_orders
    get '/orders/search'     , as: :search_orders
    
  end
  
  patch '/users/:user_id/update_address' => 'users#update_address'
  
  # resources :products, only: [:index, :show] do
  #   resources :orders, only: [:new, :create]
  #   collection do
  #     # get :search
  #   end
  # end
  
  # resources :sales, only: [:show]
  
  get '/sale-:id' => 'sales#show', as: :sale
  get '/items/category/:type_id' => 'products#index', as: :category_items
  get '/item-:id' => 'products#show', as: :product
  
  # 重置密码相关
  get '/account/forget_password'        => 'user_steps#new',        as: :forget_password
  post '/account/forget_password'       => 'user_steps#create',     as: :forget_password_account
  get '/account/verify_user'            => 'user_steps#find',       as: :find_password
  post '/account/verify_user'           => 'user_steps#check_code', as: :check_code
  get '/account/modify_password'        => 'user_steps#edit',       as: :edit_password
  post '/account/modify_password'       => 'user_steps#update',     as: :password
  get '/account/modify_password_result' => 'user_steps#complete',   as: :complete_password
  
  resources :line_items, only: [:create, :update, :destroy]
  resources :carts, only: [:show]
  get '/cart' => 'carts#show', as: :show_cart
  
  get '/search' => 'products#search', as: :search
  
  resources :orders, except: [:index, :update, :destroy, :edit, :new] do    
    member do 
      patch :cancel
      # patch :complete
    end
  end
  get '/checkout' => 'orders#new', as: :checkout
  
  resources :apartments, only: [:index]
  resources :newsblasts, path: "news", only: [:show]
  resources :invites, only: [:new, :create, :update]
  get '/invite/active' => 'invites#active', as: :active_invite
  patch '/invite/active_code' => 'invites#update', as: :active_code_invite
  
  namespace :cpanel do
    root 'home#index'
    resources :site_configs, only: [:index, :edit, :create, :update, :destroy, :new]
    resources :orders do
      member do
        patch :cancel
        patch :complete
        patch :prepare_deliver
        patch :deliver
      end
      collection do
        get :search
        get :today_normal
        get :completed
        get :canceled 
      end
    end
    
    resources :pages
    
    resources :banners
    resources :invites
    resources :messages
    resources :newsblasts
    resources :sales
    resources :sidebar_ads
    
    resources :products do
      member do
        patch :upshelf
        patch :downshelf
        patch :unsuggest
        patch :suggest
      end
    end
    
    resources :users do
      member do
        patch :block
        patch :unblock
      end
    end
    resources :product_types
    resources :apartments do
      member do
        patch :open
        patch :close
      end
    end
  end
  
  # constraints :subdomain => "api" do
  mount Shuiguoshe::APIV1 => '/'
  # end
  
  match '*path', via: :all, to: 'home#error_404'
  
end
