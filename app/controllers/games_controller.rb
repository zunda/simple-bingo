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
      if @game.save
        redirect_to @game
      end
    rescue GameError => e
      flash[:error] = e.message
      redirect_to @game
    end
  end
end
