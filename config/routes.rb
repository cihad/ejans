Ejans::Application.routes.draw do
  root :to => 'node_types#index'
  match "/404", :to => "errors#not_found"
  resources :home, only: [:index, :show]

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  resources :comments, :only => [:create, :destroy]

  # Node Types, Fields, Views, Nodes
  resources :node_types, path: 'nt' do
    namespace :custom_fields do
      resources :fields do
        post :sort, on: :collection

        resources :options, only: [:create, :destroy] do
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
      get :change_status, on: :member

      resources :images do
        post :sort, on: :collection
      end
    end
  end

  resources :places do
    get :find_by_name, on: :collection
  end
  resources :categories

  mount Resque::Server, at: "/resque"
end
