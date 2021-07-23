require "test_helper"

class CardTest < ActiveSupport::TestCase
  test "creation of a Card" do
    game = Game.create
    card = Card.create(game: game)
    assert_match Uuid_regex, card.id, "Primary key is not a UUID"
    assert_match Uuid_regex, card.game_id, "Id for the game is not a UUID"
    assert_equal Card::Size * Card::Size, card.cells.size
  end

  test "deletion of Cards through a Game" do
    game = Game.create
    Card.create(game: game)
    Card.create(game: game)
    assert_difference "Card.count", -2 do
      game.destroy!
    end
  end

  test "assignment of numbers to cells" do
    card = Card.create
    assert_nil card.cell_at(2,2)
    numbers = card.cells.compact
    assert_equal 24, numbers.size
    assert_equal 24, numbers.uniq.size
  end

  test "counts reaches" do
    game = Game.create
    card = Card.create(game: game)
    assert_equal 0, card.reaches
    4.times do |i|
      game.draw(card.cell_at(i, i)) unless i == 2
    end
    assert_equal 1, card.reaches

    4.times do |i|
      game.draw(card.cell_at(i, 4 - i)) unless i == 2
    end
    assert_equal 2, card.reaches

    4.times do |i|
      game.draw(card.cell_at(1, i)) unless i == 1 or i == 3
    end
    assert_equal 3, card.reaches

    4.times do |i|
      game.draw(card.cell_at(i, 1)) unless i == 1 or i == 3
    end
    assert_equal 4, card.reaches
  end

  test "detects bingo from top left to bottom right" do
    game = Game.create
    card = Card.create(game: game)
    assert_not card.bingo
    5.times do |i|
      game.draw(card.cell_at(i, i)) unless i == 2
    end
    assert card.bingo
  end

  test "detects bingo from bottom left to top right" do
    game = Game.create
    card = Card.create(game: game)
    assert_not card.bingo
    5.times do |i|
      game.draw(card.cell_at(i, 4 - i)) unless i == 2
    end
    assert card.bingo
  end

  test "detects bingo in a row" do
    game = Game.create
    card = Card.create(game: game)
    assert_not card.bingo
    5.times do |i|
      game.draw(card.cell_at(i, 1))
    end
    assert card.bingo
  end

  test "detects bingo in a column" do
    game = Game.create
    card = Card.create(game: game)
    assert_not card.bingo
    5.times do |i|
      game.draw(card.cell_at(1, i))
    end
    assert card.bingo
  end

  test "can claim with bingo" do
    game = Game.create
    card = Card.create(game: game)
    assert_not card.claimed
    5.times do |i|
      game.draw(card.cell_at(1, i))
    end
    assert_nothing_raised do
      card.claim
    end
    assert card.claimed
  end

  test "cannot claim without bingo" do
    card = Card.create(game: Game.create)
    assert_raises CardError do
      card.claim
    end
  end
end
