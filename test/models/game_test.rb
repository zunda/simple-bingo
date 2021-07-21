require "test_helper"

class GameTest < ActiveSupport::TestCase
	test "creation of a Game" do
		game = Game.create
		assert_match Uuid_regex, game.id, "Primary key is not a UUID"
  end
end
