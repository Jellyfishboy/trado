Trado::Application.routes.draw do

  mount RedactorRails::Engine => '/redactor_rails'

  root :to => 'store#index'

  # Standard pages
  get '/about' => 'store#about'
  get '/contact' => 'store#contact'

  get '/update_country' => 'orders#update_country'
  get '/update_sku' => 'products#update_sku'
  get '/paypal/ipn' => 'transactions#paypal_ipn'
  get '/search' => 'search#results'

  devise_for :users, :controllers => { 
    :registrations => "users/registrations",
    :sessions => "users/sessions"
     }
  resources :categories, :only => :show do
    resources :products, :only => :show
  end
  resources :orders, :only => :new do
    resources :build, controller: 'orders/build', :only => [:show,:update] do
      member do
        get 'express'
        get 'purchase'
        get 'success'
        get 'failure'
        get 'purge'
      end
    end
  end

  resources :users
  resources :cart_items, :only => [:create,:update,:destroy]
  resources :notifications, :only => :create

  namespace :admin do
      root :to => "admin#dashboard"
      mount RailsAdmin::Engine => '/db'
      mount Sidekiq::Web => '/jobs'
      resources :accessories, :shippings, :tiers, :countries, :products, :categories, :except => :show
      resources :invoices 
      resources :orders, :only => [:index, :show]
      resources :transactions, :only => :index
      namespace :products do
        resources :attachments, :tags, :only => :destroy
        resources :skus, :only =>  [:index,:destroy, :edit, :update]
        namespace :skus do
          resources :attribute_types, :except => :show
        end
      end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
