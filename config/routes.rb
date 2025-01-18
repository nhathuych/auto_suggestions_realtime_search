Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "books#index"

  resources :books

  post :search, to: "search#search", as: :search
  post "search/suggestions", to: "search#suggestions", as: :search_suggestions
end
