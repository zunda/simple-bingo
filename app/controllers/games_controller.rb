class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
    @cards = @game.cards
  end

  def create
    @game = Game.create

    if @game.save
      redirect_to @game
    else
      raise RuntimeError  # Should not reach here
    end
  end

  def draw
    @game = Game.find(params[:id])

    begin
      @game.draw
      @game.save
      redirect_to @game
    rescue GameError => e
      @error = e
      render "games/error", status: :conflict
    end
  end

  def present
    @game = Game.find(params[:id])
    @card = Card.find(params[:card_id])
    if @game.id != @card.game_id
      raise RecordNotFound
    end
    begin
      @card.claim
      @card.save
      redirect_to @game
    rescue CardError => e
      @error = e
      render "games/error", status: :conflict
    end
  end
end
