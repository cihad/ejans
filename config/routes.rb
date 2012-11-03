Ejans::Application.routes.draw do
  root :to => 'node_types#index'
  match "/404", :to => "errors#not_found"
  get "home/index"

  # match "/services/:service_id/notifications/:id" => redirect("/service/%{service_id}/%{id}")
  # resources :services, path: 'services', only: [:index, :create]
  # resources :services, path: 'service'
  # resources :services, path: 'service', only: []  do
  #   post :sort, on: :collection
  #   get :selections, on: :member

  #   resources :notifications, path: '', except: :index do
  #     get :calculate, on: :collection
  #     get :statistics, on: :member
  #   end
  # end
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  resources :comments, :only => [:create, :destroy]

  # Node Types, Feature Configuration, Views
  resources :node_types, path: 'nt' do
    namespace :fields do
      resources :field_configurations do
        post :sort, on: :collection

        resources :list_items, only: [:create, :destroy] do
          post :sort, on: :collection
        end
      end
    end

    namespace :views do
      resources :views do
        post :sort, on: :collection
      end
      resource :node, only: [:edit, :update]
      resource :place_page, only: [:edit, :update]
    end

    resources :marketing
    resources :marketing_templates, path: 'mail'
    resources :potential_users

    resources :nodes, path: 'nd' do
      get :manage, on: :collection
      get :change_owner, on: :member
      post :change_owner, on: :member
    end
  end

  namespace :fields do
    resources :images do
      post :sort, on: :collection
    end
  end

  resources :places do
    get :find_by_name, on: :collection
  end
  resources :categories

  mount Resque::Server, at: "/resque"
end
