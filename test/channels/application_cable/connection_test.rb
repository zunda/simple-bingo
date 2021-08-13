require "test_helper"

class ApplicationCable::ConnectionTest < ActionCable::Connection::TestCase
  test "connects from a card with cookies" do
    c = Card.create(game_id: Game.create.id)
    cookies[:card_id] = c.id

    connect
    assert_equal c.id, connection.card_id
  end
end
