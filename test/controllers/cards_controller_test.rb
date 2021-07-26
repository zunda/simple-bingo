class CardsControllerTest < ActionDispatch::IntegrationTest
  test "should create a card" do
    g = Game.create
    assert_difference("Card.count") do
      get "/games/#{g.id}/newcard"
    end
    card_id = cookies['card_id']
    assert card_id, "Cookie for card ID is not set"
    assert_redirected_to card_path
  end

  test "showing a card sets a cookie" do
    g = Game.create
    c = Card.create(game: g)
    cookies[:card_id] = c.id
    assert_nothing_raised do
      get card_path
    end
    assert_equal c.id, cookies[:card_id], "Cookie for card ID is not set"
  end
end
