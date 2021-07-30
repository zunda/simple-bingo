class CardsControllerTest < ActionDispatch::IntegrationTest
  test "respond with a post form for card with cookie and hidden param set" do
    g = Game.create
    get card_new_path(id: g.id)
    assert_includes response.body, 'action="/card"'
    assert_includes response.body, 'method="post"'
    assert_includes response.body, 'name="game_id"'
    assert_includes response.body, %Q[value="#{g.id}"]
    assert_equal g.id, cookies[:game_id], "Cookie for game ID is not set"
  end

  test "should create a card" do
    g = Game.create
    cookies[:game_id] = g.id
    assert_difference("Card.count") do
      post card_path
    end
    assert_not cookies['card_id'].blank?, "Cookie for card ID is not set"
    assert cookies['game_id'].blank?, "Cookie for game ID remains set"
    assert_redirected_to card_path
  end

  test "redirects to card#new when trying to create a card without a cookie" do
    g = Game.create
    cookies[:game_id] = nil
    post card_path, params: { game_id: g.id }
    assert_redirected_to "/games/#{g.id}/newcard"
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
