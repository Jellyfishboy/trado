GimsonRobotics::Application.routes.draw do

  root :to => 'store#index'

  # Standard pages
  match '/about' => 'store#about'
  match '/contact' => 'store#contact'

  # Ajax methods
  match '/update_country' => 'orders#update_country'
  match '/estimate_shipping' => 'carts#estimate_shipping'
  match '/update_dimension' => 'products#update_dimension'
  match '/update_line_item' => 'orders#update_line_item'

  devise_for :users, :controllers => { 
    :registrations => "users/registrations",
    :sessions => "users/sessions"
     }
  resources :carts, :only => [:create, :show, :destroy]
  resources :categories, :only => :show do
    resources :products, :only => :show
  end
  
  resources :orders, :only => [:new, :create, :update_country, :update_line_item]

  resources :users
  resources :line_items, :only => [:create, :destroy, :update]

  namespace :admin do
      root :to => "admin#dashboard"
      mount RailsAdmin::Engine => '/db'
      mount Sidekiq::Web => '/jobs'
      mount RedactorRails::Engine => '/redactor'
      resources :products, :except => :show
      resources :accessories, :dimensions, :invoices, :shippings, :tiers, :countries, :attachments, :tags, :pay_types
      resources :categories, :except => :show
      resources :orders
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
