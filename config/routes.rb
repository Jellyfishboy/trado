Trado::Application.routes.draw do

  mount RedactorRails::Engine => '/redactor_rails'

  root :to => 'store#index'

  # Standard pages
  get '/about' => 'store#about'
  get '/contact' => 'store#contact'

  # Store
  get '/order/shippings/update' => 'shippings#update'
  get '/product/skus/update' => 'skus#update'
  get '/product/accessories/update' => 'accessories#update'
  get '/search' => 'search#results'
  get '/search/autocomplete' => 'search#autocomplete'

  # Error pages
  %w( 404 422 500 ).each do |code|
    get code, :to => "errors#show", :code => code
  end


  devise_for :users, :controllers => { 
    :registrations => "users/registrations",
    :sessions => "users/sessions"
     }
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
  resources :categories, :only => :show do
    resources :products, :only => :show
  end
  resources :users
  resources :cart_items, :only => [:create,:update,:destroy]
  resources :cart_item_accessories, :only => [:update, :destroy]
  resources :notifications, :only => :create
  resources :addresses, :only => [:new, :create, :update]
  resources :skus, :only => :edit

  

  namespace :admin do
      root :to => "categories#index"
      mount RailsAdmin::Engine => '/db'
      post '/paypal/ipn' => 'transactions#paypal_ipn'
      resources :accessories, :shippings, :products, :categories, :countries, :except => :show
      resources :orders, :only => [:index, :show, :update]
      resources :transactions, :only => :index
      namespace :products do
        resources :attachments, :tags, :only => :destroy
        resources :skus, :only =>  [:index, :destroy, :edit, :update]
        namespace :skus do
          resources :attribute_types, :except => :show
          resources :stock_levels, :only => [:create, :new]
        end
      end
      namespace :shippings do
        resources :tiers, :except => :show
      end
      namespace :countries do
        resources :zones, :tax_rates, :except => :show
      end
      get '/settings' => 'admin#settings'
      put '/settings/update' => 'admin#update'
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
