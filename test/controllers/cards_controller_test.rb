class CardsControllerTest < ActionDispatch::IntegrationTest
  test "should create a card" do
    g = Game.create
    assert_difference("Card.count") do
      get "/games/#{g.id}/newcard"
    end
    jar = ActionDispatch::Cookies::CookieJar.build(request, cookies.to_hash)
    card_id = jar.signed['card_id']
    assert card_id, "Cookie for card ID is not set"
    assert_redirected_to card_path(card_id)
  end

  test "showing a card sets a cookie" do
    g = Game.create
    c = Card.create(game: g)
    get card_path(c.id)
    jar = ActionDispatch::Cookies::CookieJar.build(request, cookies.to_hash)
    card_id = jar.signed['card_id']
    assert_equal c.id, card_id, "Cookie for card ID is not set"
  end
end
