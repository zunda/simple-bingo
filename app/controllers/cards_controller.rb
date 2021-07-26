class CardsController < ApplicationController
  def new
    # called at /games/:game_id/newcard
    @game = Game.find(params[:id])
    @card = Card.create(game: @game)

    if @card.save
      cookies.signed[:card_id] = { value: @card.id, expires: 1.week }
      redirect_to @card
    end
  end

  def show
    @card = Card.find(params[:id])
  end
end
