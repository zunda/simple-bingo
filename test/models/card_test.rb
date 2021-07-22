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
      game.draw(card.cell_at(1, i))
    end
    assert_equal 3, card.reaches

    4.times do |i|
      game.draw(card.cell_at(i, 1))
    end
    assert_equal 4, card.reaches
  end
end
