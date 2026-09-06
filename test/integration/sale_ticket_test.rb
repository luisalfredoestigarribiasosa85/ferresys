require "test_helper"

class SaleTicketTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:owner_one))
  end

  test "shows a printable ticket for a completed sale" do
    sale = sales(:one_completed)

    get ticket_sale_path(sale)

    assert_response :success
    assert_match(/TICKET DE VENTA/, response.body)
    assert_match(/#000001/, response.body)
    assert_match(/Cemento 50kg/, response.body)
    assert_match(/Destornillador plano/, response.body)
    assert_match(/97.000/, response.body)
    assert_match(/Imprimir/, response.body)
  end

  test "marks a cancelled sale ticket as anulada" do
    sale = sales(:one_cancelled)

    get ticket_sale_path(sale)

    assert_response :success
    assert_match(/ANULADA/, response.body)
  end

  test "a tenant cannot view the ticket of another account sale" do
    sale = sales(:other_account_sale)

    get ticket_sale_path(sale)

    assert_response :not_found
  end

  private

  def sign_in(user)
    post session_path, params: { email: user.email, password: "password123" }
  end
end