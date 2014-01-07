GimsonRobotics::Application.routes.draw do

  root :to => 'store#index'

  # Standard pages
  match '/about' => 'store#about'
  match '/contact' => 'store#contact'

  # Ajax methods
  match '/update_country' => 'orders#update_country'
  match '/update_dimension' => 'products#update_dimension'

  get '/search' => 'search#results'

  devise_for :users, :controllers => { 
    :registrations => "users/registrations",
    :sessions => "users/sessions"
     }
  resources :carts
  resources :categories do
    resources :products
  end
  resources :orders do
    resources :build, controller: 'orders/build' do
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
  resources :line_items

  namespace :admin do
      root :to => "admin#dashboard"
      mount RailsAdmin::Engine => '/db'
      mount Sidekiq::Web => '/jobs'
      resources :accessories, :dimensions, :invoices, :shippings, :tiers, :countries, :attachments, :tags, :skus, :variant_values, :variants, :categories, :orders, :products
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
