require "test_helper"

class CardChannelTest < ActionCable::Channel::TestCase
  test "subscribes" do
    stub_connection card_id: Card.create(game_id: Game.create.id).id
    subscribe
    assert subscription.confirmed?
  end

  test "receive draw for game" do
    g = Game.create
    st = "game_#{g.id}_draw"
    stub_connection card_id: Card.create(game_id: g.id).id
    subscribe
    assert_has_stream st
    assert_broadcasts(st, 1) do
      g.draw
    end
  end
end
