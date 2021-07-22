require "test_helper"

class CardTest < ActiveSupport::TestCase
  test "creation of a Card" do
    game = Game.create
    card = Card.create(game: game)
    assert_match Uuid_regex, card.id, "Primary key is not a UUID"
    assert_match Uuid_regex, card.game_id, "Id for the game is not a UUID"
    assert_equal 25, card.cells.size
  end

  test "deletion of Cards through a Game" do
    game = Game.create
    Card.create(game: game)
    Card.create(game: game)
    assert_difference "Card.count", -2 do
      game.destroy!
    end
  end
end