require "test_helper"

class ImportFlowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:owner_one))
  end

  test "imports products from a CSV and redirects" do
    file = fixture_file_upload("productos.csv", "text/csv")
    csv_content = file.read

    post imports_path, params: { file: fixture_file_upload("productos.csv", "text/csv") }
    assert_response :success

    assert_difference "Product.where(account: accounts(:one)).count", 2 do
      post imports_path, params: { confirm: "1", csv_content: csv_content }
      assert_redirected_to products_path
      follow_redirect!
    end

    assert_response :success
    assert_match(/2 producto/, response.body)
  end

  test "shows preview and reports invalid rows without importing" do
    file = fixture_file_upload("productos_invalidos.csv", "text/csv")

    assert_no_difference "Product.where(account: accounts(:one)).count" do
      post imports_path, params: { file: file }
    end

    assert_response :success
    assert_select "h2", /Revisar importación/
    assert_match(/Correctas/, response.body)
    assert_match(/Con errores/, response.body)
  end

  test "downloads the template csv" do
    get template_imports_path
    assert_response :success
    assert_match(/nombre,sku,categoria,/, response.body)
  end

  private

  def sign_in(user)
    post session_path, params: { email: user.email, password: "password123" }
  end
end
