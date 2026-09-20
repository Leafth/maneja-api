Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      namespace :auth do
        post "login", to: "sessions#create"
        post "refresh", to: "tokens#create"
        get "me", to: "sessions#show"
        delete "logout", to: "sessions#destroy"
      end

      get "health", to: "health#show"
    end
  end
end
