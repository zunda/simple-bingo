Rails.application.routes.draw do
  root "games#index"

  resources :games
  put "games/:id/draw", to: "games#draw"
end
