require 'securerandom'

class CardError < StandardError; end

class Card < ApplicationRecord
  belongs_to :game

  Size = 5
  Scanner = Array(0...Size).freeze
  # https://ja.wikipedia.org/wiki/%E3%83%93%E3%83%B3%E3%82%B4
  Numbers = [
    Array(1..15).freeze,
    Array(16..30).freeze,
    Array(31..45).freeze,
    Array(46..60).freeze,
    Array(61..75).freeze,
  ].freeze

  after_initialize do
    # update current states
    @current_cells = cells.dup  # opened cells will be nil
    @current_draws = 0
    @current_reaches = 0
    @current_bingo = false
    update_states if 0 < game.draws.size
  end

  before_create do
    center = (Size - 1)/2
    # populate cells with numbers
    0.upto(Size - 1) do |col|
      n = Numbers[col].dup.shuffle(random: SecureRandom)
      0.upto(Size - 1) do |row|
        self.cells[Card.cell_index(col, row)] =
          unless col == center and row == center
            n.pop
          else
            nil # free spot at the center
          end
      end
    end
    @current_cells = cells.dup
  end

  def Card.cell_index(col, row)
    return col * Size + row
  end

  def cell_at(col, row)
    return self.cells[Card.cell_index(col, row)]
  end

  def state_at(col, row)
    return @current_cells[Card.cell_index(col, row)]
  end

  def reaches
    update_states if @current_draws < game.draws.size
    return @current_reaches
  end

  def bingo
    update_states if @current_draws < game.draws.size
    return @current_bingo
  end

  def claim
    update_states if @current_draws < game.draws.size
    unless @current_bingo
      raise CardError, "ビンゴになっていません"
    end
    self.claimed = true
  end

  def to_s
    update_states if @current_draws < game.draws.size

    return Scanner.map{|row|
      Scanner.map{|col|
        c = state_at(col, row)
        n = cell_at(col, row)
        "#{c ? " " : "["}#{n ? "%02d" % n : "--"}#{c ? " " : "]"}"
      }.join + "\n"
    }.join + "Reach: #{@current_reaches}\nBingo: #{@current_bingo}\nClaimed: #{claimed}"
  end

  def update_states
    @current_draws.upto(game.draws.size - 1) do |i|
      j = cells.index(game.draws[i])
      if j
        @current_cells[j] = nil
        if not @current_bingo and i >= Size - 2 
          _detect_bingo(i + 1)
        end
      end
    end
    @current_draws = game.draws.size
    _count_reaches
  end

  private
  def _count_reaches
    @current_reaches = 0
    if Scanner.map{|i| @current_cells[Card.cell_index(i, i)]}.count{|c| c} == 1
      @current_reaches += 1
    end
    if Scanner.map{|i| @current_cells[Card.cell_index(i, Size - 1 - i)]}.count{|c| c} == 1
      @current_reaches += 1
    end
    Scanner.each do |i|
      if Scanner.map{|j| @current_cells[Card.cell_index(i, j)]}.count{|c| c} == 1
        @current_reaches += 1
      end
      if Scanner.map{|j| @current_cells[Card.cell_index(j, i)]}.count{|c| c} == 1
        @current_reaches += 1
      end
    end
  end

  def _detect_bingo(draws)
    if
      Scanner.map{|i| @current_cells[Card.cell_index(i, i)]}.count{|c| c} == 0 or
      Scanner.map{|i| @current_cells[Card.cell_index(i, 4 - i)]}.count{|c| c} == 0
    then
      @current_bingo = draws
      return
    end
    Scanner.each do |i|
      if
        Scanner.map{|j| @current_cells[Card.cell_index(i, j)]}.count{|c| c} == 0 or
        Scanner.map{|j| @current_cells[Card.cell_index(j, i)]}.count{|c| c} == 0
      then
        @current_bingo = draws
        return
      end
    end
  end
end
