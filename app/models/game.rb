require 'securerandom'

class GameError < StandardError; end

class Game < ApplicationRecord
  has_many :cards, dependent: :destroy

  Numbers = (1..75).to_a.freeze

  def draw(ball = nil)
    unless ball
      balls = Numbers - draws
      if balls.empty?
        raise GameError, "全部の数字を抽選してしまいました"
      end
      ball = balls.sample(random: SecureRandom)
    end
    draws.push ball
    ActionCable.server.broadcast("game_#{id}_draw", { drawn: ball })
    return ball
  end
end
