class CardsController < ApplicationController
  def new
    # GET to "games/:id/newcard"
    @game = Game.find(params[:id])
    cookies[:game_id] = { value: @game.id, expires: 1.week }
  end

  def create
    game_id = cookies[:game_id]
    if game_id.blank?
      flash[:error] = "ビンゴカードの取得にはクッキーが必要です"
      redirect_to "/games/#{params[:game_id]}/newcard"
    else
      @game = Game.find(game_id)
      @card = Card.create(game: @game)

      @card.save
      cookies[:card_id] = { value: @card.id, expires: 1.week }
      redirect_to card_path
    end
  end

  def show
    @card = Card.find(cookies['card_id'])
    cookies[:card_id] = { value: @card.id, expires: 1.week }
  end
end
