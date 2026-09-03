Rails.application.routes.draw do
  # Public auth
  get  "signup", to: "registrations#new"
  post "signup", to: "registrations#create"
  resource :session, only: %i[new create destroy]

  # Authenticated area
  root "dashboard#index"

  resources :products
  resources :categories
  resources :customers
  resources :suppliers
  resources :employees, controller: "users", only: %i[index new create]
  resources :sales do
    patch :cancel, on: :member
  end
  resources :stock_movements, only: %i[index new create]
  resources :dashboard, only: :index

  # Reveal health status on /up
  get "up" => "rails/health#show", as: :rails_health_check
end