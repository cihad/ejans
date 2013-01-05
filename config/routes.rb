Ejans::Application.routes.draw do

  root :to => 'node_types#index'

  get '/user'      => 'users#show'

  devise_for :users,
    path: 'user',
    path_names: { sign_in: "signin", sign_out: "signout", sign_up: "signup" }

  as :user do
    get    "/signin"  => "devise/sessions#new",       as: :signin
    delete "/signout" => "devise/sessions#destroy",   as: :signout
    get    "/signup"  => "devise/registrations#new",  as: :signup
    get  '/user/edit' => 'devise/registrations#edit', as: :edit_user
  end

  match "/404", :to => "errors#not_found"

  resources :home, only: [:index, :show]

  resources :comments, :only => [:create, :destroy]

  # Node Types, Fields, Views, Nodes
  resources :node_types, path: 'nt' do
    get :manage, on: :member
    
    namespace :custom_fields do
      resources :fields do
        post :sort, on: :collection

        resources :options, only: [:create, :destroy] do
          post :sort, on: :collection
        end
      end
    end

    resources :node_type_views do
      post :sort, on: :collection
    end
    resource :node_view, only: [:edit, :update]
    resource :place_page_view, only: [:edit, :update]

    resources :mailers
    resources :mailer_templates, path: 'mail'
    resources :potential_users

    resources :nodes, path: 'nd' do
      get :change_owner, on: :member
      post :change_owner, on: :member
      get :change_status, on: :member

      resources :images do
        post :sort, on: :collection
        post :add_image, on: :collection
      end
    end
  end

  resources :places do
    get :find_by_name, on: :collection
  end
  resources :categories

  mount Resque::Server, at: "/resque"
end
