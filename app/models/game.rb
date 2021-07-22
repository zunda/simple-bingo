require 'securerandom'

class Game < ApplicationRecord
  has_many :cards, dependent: :destroy

  Numbers = (1..75).to_a.freeze

  def draw(ball = nil)
    unless ball
      balls = Numbers - draws
      if balls.empty?
        raise RuntimeError, "No more numbers to draw"
      end
      ball = balls.sample(random: SecureRandom)
    end
    draws.push ball
    return ball
  end
end
