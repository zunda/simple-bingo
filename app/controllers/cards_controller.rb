class CardsController < ApplicationController
  def new
    # GET to "games/:id/newcard"
    @game = Game.find(params[:id])
  end

  def create
    @game = Game.find(params[:game_id])
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
