require "test_helper"

class KegInventoryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get keg_inventory_index_url
    assert_response :success
  end

  test "should get show" do
    get keg_inventory_show_url
    assert_response :success
  end
end
