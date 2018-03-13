require 'test_helper'

class BusStopControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bus_stop_index_url
    assert_response :success
  end

end
