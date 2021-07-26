class CardsController < ApplicationController
  def new
    # called at /games/:game_id/newcard
    @game = Game.find(params[:id])
    @card = Card.create(game: @game)

    if @card.save
      cookies[:card_id] = { value: @card.id, expires: 1.week }
      redirect_to card_path
    end
  end

  def show
    card_id = cookies['card_id']
    @card = Card.find(card_id)
    cookies[:card_id] = { value: @card.id, expires: 1.week }
  end
end
