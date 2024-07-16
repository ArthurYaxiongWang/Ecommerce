Rails.application.routes.draw do
  root 'welcome#index'

  devise_for :users, controllers: { registrations: 'registrations' }
  devise_for :admin_users, path: 'admin', controllers: { sessions: 'admin/sessions' }

  resources :categories, only: [:show]
  resources :products, only: [:show] do
    get :search, on: :collection
  end
  resources :shopping_carts, only: [:index, :create, :update, :destroy]
  resources :addresses do
    member do
      put :set_default_address
    end
  end
  resources :orders do
    collection do
      get :calculate_taxes
    end
  end
  resources :payments, only: [:index] do
    collection do
      get :generate_pay
      get :pay_return
      get :pay_notify
      get :success
      get :failed
    end
  end
  resources :cellphone_tokens, only: [:create]

  namespace :dashboard do
    scope 'profile' do
      controller :profile do
        get :password
        put :update_password, as: :update_password
      end
    end

    resources :orders, only: [:index]
    resources :addresses, only: [:index]
  end

  namespace :admin do
    root 'dashboard#index'
    resources :sessions, only: [:new, :create, :destroy]
    resources :categories
    resources :products do
      resources :product_images, only: [:index, :create, :destroy, :update]
    end
    resources :abouts, only: [:edit, :update]
    resources :contacts, only: [:edit, :update]
  end

  get '/about', to: 'abouts#show', as: :about
  get '/contact', to: 'contacts#show', as: :contact
end
