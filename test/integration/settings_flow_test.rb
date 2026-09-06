require "test_helper"

class SettingsFlowTest < ActionDispatch::IntegrationTest
  test "owner updates the account settings" do
    sign_in(users(:owner_one))

    patch settings_path, params: {
      account: {
        name: "Ferretería Central",
        address: "Av. Ygatimí 245",
        phone: "0981 123 456",
        ticket_footer: "Los precios pueden variar"
      }
    }

    assert_redirected_to edit_settings_path
    assert_match(/Configuración guardada/, flash[ :notice ])

    account = accounts(:one).reload
    assert_equal "Ferretería Central", account.name
    assert_equal "Av. Ygatimí 245", account.address
    assert_equal "0981 123 456", account.phone
    assert_equal "Los precios pueden variar", account.ticket_footer
  end

  test "ticket shows the company data and footer" do
    accounts(:one).update!(address: "Av. Ygatimí 245", phone: "0981 123 456", ticket_footer: "Los precios pueden variar")
    sign_in(users(:owner_one))

    get ticket_sale_path(sales(:one_completed))

    assert_response :success
    assert_match(/Ferretería Uno/, response.body)
    assert_match(/Av\. Ygatimí 245/, response.body)
    assert_match(/Tel: 0981 123 456/, response.body)
    assert_match(/Los precios pueden variar/, response.body)
  end

  test "employee cannot access settings" do
    sign_in(users(:employee_one))

    get edit_settings_path

    assert_redirected_to root_path
    assert_match(/permisos de administrador/, flash[ :alert ])
  end

  private

  def sign_in(user)
    post session_path, params: { email: user.email, password: "password123" }
  end
end