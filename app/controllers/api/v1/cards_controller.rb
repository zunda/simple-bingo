class Api::V1::CardsController < ApplicationController
  def show
    @card = Card.find(cookies['card_id'])
    _show
  end

  def show_with_id
    @card = Card.find(params['id'])
    _show
  end

  private
  def _show
    cookies[:card_id] = { value: @card.id, expires: 1.week }
    render json:
      {
        # 1-d array that scans cells vertically with null for open cells
        cells: @card.states,
        bingo: @card.bingo,
        reaches: @card.reaches,
        claimed: @card.claimed,
      }
  end
end
