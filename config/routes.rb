Ejans::Application.routes.draw do
  # 404
  match "/404", :to => "errors#not_found"

  # Home
  root :to => 'home#index'
  get "home/index"
  get "home/close_slide"

  # Admin
  namespace :admin do
    resources :roles
    resources :payment_types
    resources :notifications, :only => [:index, :update] do
      put :publish, :on => :member
    end
  end

  # Account
  scope "accounts" do
    resources :subscriptions, :except => [:new, :edit] do
      put :multiple_update, :on => :collection
      get :edit, :on => :collection
    end

    resources :payments, :only => [:index, :new, :create] do
      get :history, :on => :collection
    end

    get "settings/email", :to => "settings#email"
    get "settings/password", :to => "settings#password"
    get "settings/terminate", :to => "settings#terminate"
    put "settings/update_email", :to => "settings#update_email"
    put "settings/update_password", :to => "settings#update_password"
  end

  devise_for :accounts

  # Service
  resources :services do
    post :sort, :on => :collection
    get :selections, :on => :member

    resources :notifications, :except => :index do
      get :calculate, :on => :collection
      get :statistics, :on => :member
    end
  end
  resources :notices, :only => :create
  resources :selections, :only => [:create, :destroy] do
    post :multiple_add, on: :collection
  end

  resources :comments, :only => [:create, :destroy]

  resources :filters, :only => [:create, :destroy]
  resources :ideas, :only => [:create, :destroy]

  mount Resque::Server, :at => "/resque"

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
  # match ':controller(/:action(/:id(.:format)))'
end
