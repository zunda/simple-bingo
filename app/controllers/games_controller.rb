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
end
