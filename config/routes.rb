Rails.application.routes.draw do
  root "games#index"

  # for organizers
  resources :games, only: [:index, :show, :create]
  put "/games/:id/draw", to: "games#draw", as: :game_draw
  put "/games/:id/cards/:card_id/present", to: "games#present", as: :game_present

  # for players
  get "/games/:id/newcard", to: "cards#new", as: :card_new
  post "/card", to: "cards#create"
  get "/card", to: "cards#show"

  # for debug
  get "/card/:id", to: "cards#show_with_id", as: :card_with_id
end
