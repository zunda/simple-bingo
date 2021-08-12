class CardChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "game_#{Card.find(card_id).game_id}_draw"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
