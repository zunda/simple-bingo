Rails.application.routes.draw do
  root "games#index"

  # for organizers
  resources :games, only: [:index, :show, :create]
  put "games/:id/draw", to: "games#draw"

  # for players
  get "games/:id/newcard", to: "cards#new"
  post "card", to: "cards#create"
  get "card", to: "cards#show"
end
