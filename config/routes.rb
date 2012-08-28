Ejans::Application.routes.draw do
  root :to => 'home#index'
  match "/404", :to => "errors#not_found"
  get "home/index"

  match "/services/:service_id/notifications/:id" => redirect("/service/%{service_id}/%{id}")
  resources :services, path: 'services', only: [:index, :create]
  resources :services, path: 'service'
  resources :services, path: 'service', only: []  do
    post :sort, on: :collection
    get :selections, on: :member

    resources :notifications, path: '', except: :index do
      get :calculate, on: :collection
      get :statistics, on: :member
    end
  end

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

  resources :notices, :only => :create
  resources :selections, :only => [:create, :destroy] do
    post :multiple_add, on: :collection
  end

  resources :comments, :only => [:create, :destroy]

  resources :filters, :only => [:create, :destroy]
  resources :ideas, :only => [:create, :destroy]

  # Admin Pages
  namespace :admin do
    resources :roles
    resources :payment_types
    resources :notifications, :only => [:index, :update] do
      put :publish, :on => :member
    end
    resources :external_sources, :only => [:index, :new, :destroy]
    resources :accounts, only: [:index]
  end

  # Node Types, Feature Configuration, Views
  resources :node_types do

    namespace :features do
      resources :feature_configurations do
        post :sort, on: :collection
      end
    end

    namespace :views do
      resources :views do
        post :sort, on: :collection
      end
      resource :node, only: [:edit, :update]
    end

    resources :nodes
  end

  resources :list_items, only: [:create]

  namespace :features do
    resources :images do
      post :sort, on: :collection
    end
  end

  resources :places

  mount Resque::Server, :at => "/resque"
end
