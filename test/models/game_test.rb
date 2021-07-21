require "test_helper"

class GameTest < ActiveSupport::TestCase
	test "creation of a Game" do
		game = Game.create
		assert_match Uuid_regex, game.id, "Primary key is not a UUID"
		assert_empty game.draws
  end

	test "draws in a Game" do
		game = Game.create
		game.draw
		assert_equal 1, game.draws.size
		assert_instance_of Integer, game.draws[0]
		game.draw
		assert_equal 2, game.draws.size
		assert_instance_of Integer, game.draws[1]
	end

	test "never draw the same number twice in a Game" do
		game = Game.create
		Game::Numbers.size.times do
			game.draw
		end
		assert_equal game.draws, game.draws.uniq
	end

	test "avois drawing too many times" do
		game = Game.create
		Game::Numbers.size.times do
			game.draw
		end
		assert_raises RuntimeError do
			game.draw
		end
	end

	test "draw returns the drawn number" do
		game = Game.create
		number = game.draw
		assert_equal game.draws[-1], number
	end

	test "games are locked to avoid concurrent draws" do
		game = Game.create
		uuid = game.id

		g1 = Game.find(uuid)
		g2 = Game.find(uuid)

		g1.draw
		g2.draw

		g1.save
		assert_raises(ActiveRecord::StaleObjectError){ g2.save }
	end
end
