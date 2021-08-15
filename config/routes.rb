Rails.application.routes.draw do
  root "games#index"

  # for organizers
  resources :games, only: [:index, :show, :create]
  post "/games/:id/draw", to: "games#draw", as: :game_draw
  post "/games/:id/cards/:card_id/present", to: "games#present", as: :game_present

  # for players
  get "/games/:id/newcard", to: "cards#new", as: :card_new
  post "/card", to: "cards#create"
  get "/card", to: "cards#show", defaults: {format: :html}

  # for debug
  get "/card/:id", to: "cards#show_with_id", as: :card_with_id
end
