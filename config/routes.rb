Rails.application.routes.draw do
  root 'welcome#index'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :categories, only: [:show]
  resources :products, only: [:show] do
    get :search, on: :collection
  end
  resources :shopping_carts, only: [:index, :create, :update, :destroy]
  resources :addresses, except: [:show] do
    member do
      put :set_default_address
    end
  end
  resources :orders
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
        put :update_password
      end
    end

    resources :orders, only: [:index]
    resources :addresses, only: [:index]
  end

  namespace :admin do
    get 'sessions/new'
    root 'sessions#new'
    resources :sessions
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
