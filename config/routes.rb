Rails.application.routes.draw do
  # Rotas de autenticação e perfil
  post "/login", to: "users#login"
  get "/users/profile", to: "users#profile"
  put "/users/profile", to: "users#update_profile"
  
  # Recursos REST
  resources :perfils
  resources :anuncios
  resources :locals
  resources :coordenadas
  resources :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
