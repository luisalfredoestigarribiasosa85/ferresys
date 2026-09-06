require "test_helper"

class DashboardTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:owner_one))
  end

  test "shows pending credit and top products summary" do
    get root_path

    assert_response :success
    assert_match(/Cuentas por cobrar/, response.body)
    assert_match(/30.000/, response.body)
    assert_match(/Top productos del mes/, response.body)
    assert_match(/Cemento 50kg/, response.body)
    assert_match(/Ventas del mes por vendedor/, response.body)
    assert_match(/Dueño Uno/, response.body)
  end

  test "tenant dashboard does not leak another account data" do
    sign_in(users(:owner_two))

    get root_path

    assert_response :success
    assert_no_match(/Cemento 50kg/, response.body)
    assert_no_match(/Juan Pérez/, response.body)
  end

  private

  def sign_in(user)
    post session_path, params: { email: user.email, password: "password123" }
  end
end