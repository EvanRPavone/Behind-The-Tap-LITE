Rails.application.routes.draw do
  # Invitation routes
  # # resources :invitations, only: [:new, :create]
  # get 'accept_invitation', to: 'invitations#accept'
  # post 'complete_registration', to: 'invitations#complete_registration'
  get 'users/set_password/:invitation_token', to: 'users#set_password', as: 'set_password'
  patch 'users/update_password/:invitation_token', to: 'users#update_password', as: 'update_password'
  # Root and authentication
  root to: 'home#welcome'
  authenticated :user do
    root to: 'dashboards#show', as: :authenticated_root
  end
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  # Scoped routes based on company name
  scope '/:company_name' do
    resources :users, only: [:index, :show, :edit, :update, :destroy]

    # Move set_password and update_password outside company scope

    # Invitation routes
    resources :invitations, only: [:new, :create]
    get 'accept_invitation', to: 'invitations#accept', as: 'accept_invitation'
    get 'dashboard', to: 'dashboards#show', as: :company_dashboard
    resources :companies
    # Keg inventory routes
    get 'keg_inventory', to: 'keg_inventory#index', as: :keg_inventory
    get 'keg_inventory/:recipe_id', to: 'keg_inventory#show', as: :keg_inventory_show
    post 'share_kegs', to: 'keg_inventory#share', as: :share_kegs
    resources :brews do
      member do
        post :empty_vessel
      end
      # Adding routes for viewing all logs and specific log actions
      post :transfer_kegs, on: :member
      resources :mash_logs, only: [:index, :new, :create, :edit, :update]
      resources :boil_logs, only: [:index, :new, :create, :edit, :update] do
        collection do
          get :new_preboil
          post :create_preboil
          get :new_postboil
          post :create_postboil
        end
      end
      resources :addition_logs, only: [:index, :new, :create, :edit, :update]
      resources :yeast_and_knockout_logs, only: [:index, :new, :create, :edit, :update]
      resources :fermentation_logs, only: [:index, :new, :create]
    end

    resources :recipes
    resources :vessels
    resources :ingredients
    resources :kegs
    post 'switch_company', to: 'companies#switch_company', as: :switch_company
  end

  # Company routes
  resources :companies
end
