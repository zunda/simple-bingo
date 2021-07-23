Rails.application.routes.draw do
  root "games#index"

  get "/games", to: "games#index"
  get "/games/:id", to: "games#show"
end
