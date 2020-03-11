require 'test_helper'

class RoundsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @round = rounds(:one)
  end

  test "should get index" do
    get rounds_url, as: :json
    assert_response :success
  end

  test "should create round" do
    assert_difference('Round.count') do
      post rounds_url, params: { round: { end_date: @round.end_date, start_date: @round.start_date } }, as: :json
    end

    assert_response 201
  end

  test "should show round" do
    get round_url(@round), as: :json
    assert_response :success
  end

  test "should update round" do
    patch round_url(@round), params: { round: { end_date: @round.end_date, start_date: @round.start_date } }, as: :json
    assert_response 200
  end

  test "should destroy round" do
    assert_difference('Round.count', -1) do
      delete round_url(@round), as: :json
    end

    assert_response 204
  end
end
