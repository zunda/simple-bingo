class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
    @cards = @game.cards
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create

    if @game.save
      redirect_to @game
    end
  end
end
