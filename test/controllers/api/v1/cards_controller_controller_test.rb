require "test_helper"

class Api::V1::CardsControllerControllerTest < ActionDispatch::IntegrationTest
  test "showing a card sets a cookie" do
    g = Game.create
    c = Card.create(game: g)
    cookies[:card_id] = c.id
    assert_nothing_raised do
      get api_v1_card_path
    end
    assert_equal c.id, cookies[:card_id], "Cookie for card ID is not set"
  end
end
