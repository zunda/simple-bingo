Rails.application.routes.draw do
  root "games#index"

  resources :games, only: [:index, :show, :create]
  put "games/:id/draw", to: "games#draw"
end
