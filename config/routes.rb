Trado::Application.routes.draw do

  root to: 'store#index'

  # Standard pages
  get '/about' => 'store#about'
  get '/contact' => 'store#contact'

  # Custom routes
  get '/order/shippings/update' => 'shippings#update'
  get '/product/skus/update' => 'skus#update'
  get '/product/accessories/update' => 'accessories#update'
  get '/search' => 'search#results'
  get '/search/autocomplete' => 'search#autocomplete'

  # Error pages
  %w( 404 422 500 ).each do |code|
    get code, to: "errors#show", code: code
  end


  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions" }
  
  resources :orders, only: [:new, :update] do
    resources :build, controller: 'orders/build', only: [:show, :update] do
      member do
        get 'express'
        get 'success'
        get 'failure'
        patch 'estimate'
        get 'purge'
        delete 'purge_estimate'
      end
    end
  end
  resources :categories, only: :show do
    resources :products, only: :show
  end
  resources :users
  resources :cart_items, only: [:create,:update,:destroy]
  resources :cart_item_accessories, only: [:update, :destroy]
  resources :notifications, only: :create
  resources :addresses, only: [:new, :create, :update]
  resources :skus, only: :edit
  resources :shippings, only: [:update]

  

  namespace :admin do
      root to: "categories#index"
      mount RailsEmailPreview::Engine => '/crm'
      post '/paypal/ipn' => 'transactions#paypal_ipn'
      resources :accessories, :shippings, :products, :categories, :zones, except: :show
      resources :orders, only: [:index, :show, :update, :edit]
      resources :attachments, only: [:destroy, :update]
      namespace :products do
        resources :tags, only: :index
        resources :skus, only:  [:destroy, :edit, :update]
        namespace :skus do
          resources :attribute_types, except: :show
          resources :stock_levels, only: [:create, :new]
        end
      end
      namespace :shippings do
        resources :tiers, except: :show
      end
      namespace :zones do
        resources :countries, except: :show
      end
      get '/settings' => 'admin#settings'
      patch '/settings/update' => 'admin#update'
      get '/profile' => 'users#edit'
      patch '/profile/update' => 'users#update'
  end

end
