Rails.application.routes.draw do
  devise_for :users, skip: :all

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post "password/forgot", to: "passwords#forgot"

      namespace :auth do
        post "register", to: "registrations#create"
        post "login", to: "sessions#create"
        post "refresh", to: "tokens#create"
        get "me", to: "sessions#show"
        delete "logout", to: "sessions#destroy"
      end

      get "health", to: "health#show"
    end
  end
end
