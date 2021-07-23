require 'securerandom'

class Card < ApplicationRecord
  belongs_to :game

  Size = 5
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
        next if col == 2 and row == 2 # leave nil for free spot
        self.cells[Card.cell_index(col, row)] = n.pop
      end
    end
    @current_cells = cells.dup  # opened cells have nil
    @current_draws = 0
    @current_reaches = 0
    @current_bingo = false
  end

  def Card.cell_index(col, row)
    return col * Size + row
  end

  def cell_at(col, row)
    return cells[Card.cell_index(col, row)]
  end

  def reaches
    open_cells if @current_draws < game.draws.size
    return @current_reaches
  end

  def bingo
    open_cells if @current_draws < game.draws.size
    return @current_bingo
  end

  def claim
    self.claimed = true
  end

  def to_s
    open_cells if @current_draws < game.draws.size

    scanner = Array(0...Size).freeze
    return scanner.map{|row|
      scanner.map{|col|
        c = @current_cells[Card.cell_index(col, row)]
        n = cell_at(col, row)
        "#{c ? " " : "["}#{n ? "%02d" % n : "--"}#{c ? " " : "]"}"
      }.join + "\n"
    }.join + "Reach: #{@current_reaches}\nBingo: #{@current_bingo}\nClaimed: #{claimed}"
  end

  private
  def open_cells
    @current_draws.upto(game.draws.size - 1) do |i|
      j = cells.index(game.draws[i])
      if j
        @current_cells[j] = nil
      end
    end
    @current_draws = game.draws.size

    scanner = Array(0...Size).freeze

    @current_reaches = 0
    case scanner.map{|i| @current_cells[Card.cell_index(i, i)]}.count{|c| c}
    when 1
      @current_reaches += 1
    when 0
      @current_bingo = true
    end
    case scanner.map{|i| @current_cells[Card.cell_index(i, 4 - i)]}.count{|c| c}
    when 1
      @current_reaches += 1
    when 0
      @current_bingo = true
    end
    scanner.each do |i|
      case scanner.map{|j| @current_cells[Card.cell_index(i, j)]}.count{|c| c}
      when 1
        @current_reaches += 1
      when 0
        @current_bingo = true
      end
      case scanner.map{|j| @current_cells[Card.cell_index(j, i)]}.count{|c| c}
      when 1
        @current_reaches += 1
      when 0
        @current_bingo = true
      end
    end
  end
end
