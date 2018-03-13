require 'test_helper'

class BusControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bus_index_url
    assert_response :success
  end

end
