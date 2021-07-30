class GamesControllerTest < ActionDispatch::IntegrationTest
  test "draws a number" do
    g = Game.create
    assert_difference "Game.find(g.id).draws.size" do
      put game_draw_path(id: g.id)
    end
  end

  test "returns an error when no more numbers to draw" do
    g = Game.create
    Game::Numbers.size.times{ g.draw }
    g.save
    put game_draw_path(id: g.id)
    assert_response :conflict
  end

  test "offer a present to a card" do
    g = Game.create
    c = Card.create(game: g)
    Game::Numbers.size.times{ g.draw }
    g.save
    c.save
    put game_present_path(id: g.id, card_id: c.id)
    c.reload
    assert c.claimed
  end

  test "raises an error when presenting to invalid card" do
    g = Game.create
    c = Card.create(game: g)
    Game::Numbers.size.times{ g.draw }
    g.save
    c.save
    assert_raises do
      put game_present_path(id: "x" + g.id, card_id: c.id)
    end
  end

  test "raises an error when presenting to card without bingo" do
    g = Game.create
    c = Card.create(game: g)
    g.save
    c.save
    put game_present_path(id: g.id, card_id: c.id)
    assert_response :conflict
  end
end
