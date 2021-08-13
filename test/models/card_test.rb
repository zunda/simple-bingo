require "test_helper"

class CardTest < ActiveSupport::TestCase
  test "creation of a Card" do
    game = Game.create
    card = Card.create(game: game)
    assert_match Uuid_regex, card.id, "Primary key is not a UUID"
    assert_match Uuid_regex, card.game_id, "Id for the game is not a UUID"
    assert_equal Card::Size * Card::Size, card.cells.size
  end

  test "consistency of numbers of a Card" do
    card = Card.create(game: Game.create)
    card_id = card.id
    card.save

    c1 = Card.find(card_id).cells.dup
    c2 = Card.find(card_id).cells.dup
    assert_equal c1, c2
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
    card = Card.create(game: Game.create)
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

  test "bingo remembers draw count" do
    game = Game.create
    c1 = Card.create(game: game)
    c1.save
    assert_not c1.bingo
    5.times do |i|
      game.draw(c1.cell_at(1, i))
    end
    game.save
    assert_equal 5, c1.bingo
    c2 = Card.find(c1.id)
    assert_equal 5, c2.bingo
    5.times do |i|
      game.draw(c1.cell_at(0, i))
    end
    assert_equal 5, c1.bingo
    assert_equal 5, c2.bingo
  end

  test "state_at is up to date" do
    game = Game.create
    card = Card.create(game: game)
    assert card.state_at(1, 1)
    assert card.states[Card.cell_index(1, 1)]
    game.draw(card.cell_at(1, 1))
    assert_not card.state_at(1, 1)
    assert_not card.states[Card.cell_index(1, 1)]
  end
end
