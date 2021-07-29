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
end
