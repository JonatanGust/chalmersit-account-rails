Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}
  as :user do
    get 'reset-password' => 'devise/passwords#new', :as => :new_password
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  devise_scope :user do
    authenticated :user do
      root 'users#dashboard', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :users, only: [:index, :show] do
    collection do
      get :autocomplete
    end
  end
  resources :groups, only: [:index, :show, :edit, :update]
  patch '/groups/:id' => 'groups#update', as: :update_group
  resource :admin, only: :show

  get '/admin/mail' => 'admins#mail', as: :admin_mail
  post '/admin/send-invitations' => 'admins#send_invitations', as: :send_invitations
  namespace :admin do
    resources :groups
    resources :applications
    resources :users
  end
  patch '/admin/users/:id/update' => 'admin/users#update', as: :admin_update_user
  get '/search' => 'users#search', as: :search
  get '/me' => 'users#me', as: :me
  get '/me/edit' => 'users#edit', as: :edit_me
  patch '/me' => 'users#update', as: :update_me
  get '/users/:id/remove-avatar' => 'users#remove_avatar', as: :remove_avatar

  get '/applications/new-subscription/:id' => 'applications#new_subscription', as: :new_subscription
  get '/applications/remove-subscription/:id' => 'applications#remove_subscription', as: :remove_subscription
  match '/applications/push-to-subscribers/:id' => 'applications#push_to_subscribers', via: :get
  resources :applications, only: [:show, :index]
  # new = login to chalmers
  get '/new' => 'users#new', as: :new_me

  # lookup = check chalmers ldap and verify, redirect to register if successful, else new
  post '/lookup' => 'users#lookup', as: :lookup_me

  # register = allow user to edit chalmers data before creation
  get '/register' => 'users#register', as: :register_me

  # create = actually create user, check chalmers ldap again!
  post '/create' => 'users#create', as: :create_me

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
