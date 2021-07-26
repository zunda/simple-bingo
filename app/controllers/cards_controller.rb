class CardsController < ApplicationController
  def new
    # GET to "games/:id/newcard"
    @game = Game.find(params[:id])
    cookies[:game_id] = { value: @game.id, expires: 1.week }
  end

  def create
    game_id = cookies[:game_id]
    unless game_id
      raise CardError, "ビンゴカードの取得にはクッキーが必要です"
    end
    @game = Game.find(game_id)
    @card = Card.create(game: @game)

    if @card.save
      cookies[:card_id] = { value: @card.id, expires: 1.week }
      redirect_to card_path
    end
  end

  def show
    card_id = cookies['card_id']
    unless card_id
      raise CardError, "ビンゴカードの閲覧にはクッキーが必要です"
    end
    @card = Card.find(card_id)
    cookies[:card_id] = { value: @card.id, expires: 1.week }
  end
end
