require 'sidekiq/web'

Trado::Application.routes.draw do

	root to: 'store#home'

  	# Custom routes
  	get '/search' => 'search#results'
  	get '/search/autocomplete' => 'search#autocomplete'

  	# Error pages
  	%w( 404 422 500 ).each do |code|
  		get code, to: "errors#show", code: code
  	end

  	# Pages system
  	namespace :p do
  		get ':slug', to: 'pages#show'
  		resources :pages, only: [] do
  			post :send_contact_message, on: :collection
  		end
  	end

  	devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions" }
  	resources :users
  	resources :contacts, only: :create
  

  	resources :categories, only: :show do
  		resources :products, only: :show
  	end

    resources :products, only: [] do
      resources :skus, only: [] do
        member do
          get :update        
        end
      end
      resources :accessories, only: [] do
          get :update, on: :collection
      end
    end

    resources :skus, only: [] do
      resource :notify_me, only: [:new, :create], controller: 'products/notify_me'
    end
  
  	resources :carts, only: [] do
  		collection do
	  		get :mycart
	  		get :checkout
        %w( paypal stripe ).each do |payment|
          post "#{payment}/confirm", to: "carts/#{payment}#confirm", as: "#{payment}_confirm"
        end
  		end
  	end
    resources :cart_items, only: [:create, :update, :destroy]
    resources :delivery_service_prices, only: [:show]

  	resources :orders, only: [:destroy] do
  		member do
	  		get :retry
	  		get :confirm
	  		post :complete
  		end
      collection do
        get :success
        get :failed
      end
  		resources :addresses, only: [:new, :create, :update]
  	end

  	namespace :admin do
  		root to: "admin#dashboard"
  		authenticate :user, lambda { |u| u.role?(:admin) } do
	  		mount RedactorRails::Engine => '/redactor_rails'
	  		mount Sidekiq::Web => '/sidekiq'
  		end
	  	resources :accessories, :categories, except: :show
	  	resources :products, except: [:show, :create] do
        patch :autosave, on: :member
	  		resources :attachments, except: :index
	  		resources :skus, except: [:index, :show] do
	  			resources :stock_adjustments, only: [:create, :new]
	  		end
	  		namespace :skus do
	  			resources :sku_variants, as: 'variants', path: 'variants', controller: :variants, only: :new do
	  				collection do
              post 'create', as: 'create'
	  					patch 'update', as: 'update'
	  					delete 'destroy', as: 'destroy'
	  				end
	  			end
	  		end
	  	end
  		resources :orders, only: [:index, :show, :update, :edit] do
        delete :cancel, to: 'orders#cancel', on: :member
      end
  		resources :delivery_services, except: :show do
	  		collection do
	  			get :copy_countries
	  			post :set_countries
	  		end
  			resources :delivery_service_prices, path: 'prices', except: :show
  		end
  		namespace :products do
  			resources :tags, only: :index
  			resources :stock, only: [:index, :show]
  		end
	  	resources :pages, except: [:show, :destroy, :new, :create]
	  	get '/settings' => 'admin#settings'
	  	patch '/settings/update' => 'admin#update'
	  	get '/profile' => 'users#edit'
	  	patch '/profile/update' => 'users#update'
  	end

  	# # redirect unknown URLs to 404 error page
  	# match '*path', via: :all, to: 'errors#show', code: 404
end
