class CardsControllerTest < ActionDispatch::IntegrationTest
  test "respond with a post form for a new card with a cookie set" do
    g = Game.create
    get "/games/#{g.id}/newcard"
    assert_includes response.body, 'action="/card"'
    assert_includes response.body, 'method="post"'
    assert_equal g.id, cookies[:game_id], "Cookie for game ID is not set"
  end

  test "should create a card" do
    g = Game.create
    cookies[:game_id] = g.id
    assert_difference("Card.count") do
      post "/card"
    end
    card_id = cookies['card_id']
    assert card_id, "Cookie for card ID is not set"
    assert_redirected_to card_path
  end

  test "raises an error when create a card without a cookie" do
    assert_raises CardError do
      post "/card"
    end
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

  test "showing a card without a cookie raises" do
    g = Game.create
    c = Card.create(game: g)
    assert_raises CardError do
      get card_path
    end
  end
end
