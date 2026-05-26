Rails.application.routes.draw do
  get "investments/index"
  get "investments/new"
  get "investments/create"
  get "investments/edit"
  get "investments/update"
  get "investments/destroy"
  get "expenses/index"
  get "expenses/new"
  get "expenses/create"
  get "expenses/edit"
  get "expenses/update"
  get "expenses/destroy"
  get "incomes/index"
  get "incomes/new"
  get "incomes/create"
  get "incomes/edit"
  get "incomes/update"
  get "incomes/destroy"
  get "categories/index"
  get "categories/new"
  get "categories/create"
  get "categories/edit"
  get "categories/update"
  get "categories/destroy"
  get "dashboard/index"
  devise_for :users
  # get "home/index"
  #
  # root "home#index"

  # Dashboard protegido
  get "dashboard", to: "dashboard#index"

  # Ruta raíz pública (redirige según autenticación)
  root to: "home#index"

  resources :categories, except: [:show]
  resources :incomes, except: [:show] do
    resources :income_records, only: [:new, :create, :edit, :update]
  end
  resources :income_records, only: [:edit, :update]
  resources :expenses, except: [:show] do
    resources :expense_records, only: [:new, :create, :edit, :update]
  end
  resources :expense_records, only: [:edit, :update]
  resources :investments, except: [:show]



  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
