require 'test_helper'

class ClubsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @club = clubs(:one)
  end

  test "should get index" do
    get clubs_url, as: :json
    assert_response :success
  end

  test "should create club" do
    assert_difference('Club.count') do
      post clubs_url, params: { club: { abbreviation: @club.abbreviation, fantasy_name: @club.fantasy_name, id_club: @club.id_club, name: @club.name, position: @club.position, shield_30x30: @club.shield_30x30, shield_45x45: @club.shield_45x45, shield_60x60: @club.shield_60x60 } }, as: :json
    end

    assert_response 201
  end

  test "should show club" do
    get club_url(@club), as: :json
    assert_response :success
  end

  test "should update club" do
    patch club_url(@club), params: { club: { abbreviation: @club.abbreviation, fantasy_name: @club.fantasy_name, id_club: @club.id_club, name: @club.name, position: @club.position, shield_30x30: @club.shield_30x30, shield_45x45: @club.shield_45x45, shield_60x60: @club.shield_60x60 } }, as: :json
    assert_response 200
  end

  test "should destroy club" do
    assert_difference('Club.count', -1) do
      delete club_url(@club), as: :json
    end

    assert_response 204
  end
end
