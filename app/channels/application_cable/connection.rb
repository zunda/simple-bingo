module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :card_id
    # also identify by game_id for Game views

    def connect
      self.card_id = cookies[:card_id]
    end
  end
end
