require "test_helper"

class SessionFlowTest < ActionDispatch::IntegrationTest
  test "unauthenticated users are redirected to login" do
    get root_path
    assert_redirected_to new_session_path

    get products_path
    assert_redirected_to new_session_path
  end

  test "logging in grants access to the dashboard" do
    post session_path, params: { email: "owner@uno.com", password: "password123" }
    follow_redirect!

    assert_response :success
    assert_select "h2", "Inicio"
  end

  test "wrong credentials fail gracefully" do
    post session_path, params: { email: "owner@uno.com", password: "mala-password" }
    assert_response :unprocessable_entity
    assert_match /incorrectos/, response.body
  end

  test "a tenant cannot see products from another account" do
    sign_in(users(:owner_one))

    get products_path
    assert_response :success
    assert_no_match /Producto de otra ferretería/, response.body
  end

  private

  def sign_in(user)
    post session_path, params: { email: user.email, password: "password123" }
    assert_redirected_to root_path
  end
end