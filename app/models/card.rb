require 'securerandom'

class Card < ApplicationRecord
  belongs_to :game

  Rows = 5
  # https://ja.wikipedia.org/wiki/%E3%83%93%E3%83%B3%E3%82%B4
  Numbers = [
    Array(1..15).freeze,
    Array(16..30).freeze,
    Array(31..45).freeze,
    Array(46..60).freeze,
    Array(61..75).freeze,
  ].freeze

  after_initialize do
    # populate cells with numbers
    0.upto(4) do |col|
      n = Numbers[col].dup.shuffle(random: SecureRandom)
      0.upto(4) do |row|
        next if col == 2 and row == 2 # free spot
        cells[col * Rows + row] = n.pop
      end
    end
  end

  def cell_at(col, row)
    return cells[col * Rows + row]
  end
end
