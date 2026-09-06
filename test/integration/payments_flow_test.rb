require "test_helper"

class PaymentsFlowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:owner_one))
  end

  test "registers a payment for a credit sale" do
    sale = sales(:one_credit)

    assert_difference "Payment.count", 1 do
      post payments_path, params: {
        payment: {
          customer_id: sale.customer_id,
          sale_id: sale.id,
          amount: 15000,
          payment_method: "cash"
        }
      }
    end

    assert_redirected_to payments_path
    assert_match(/Pago registrado/, flash[ :notice ])
    assert_equal 15000, sale.reload.balance
  end

  test "rejects a payment that exceeds the balance" do
    sale = sales(:one_credit)

    assert_no_difference "Payment.count" do
      post payments_path, params: {
        payment: {
          customer_id: sale.customer_id,
          sale_id: sale.id,
          amount: 999999,
          payment_method: "cash"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_match(/supera el saldo/, response.body)
  end

  test "lists payments on the index page" do
    get payments_path

    assert_response :success
    assert_match(/Cuentas por cobrar/, response.body)
    assert_match(/Juan Pérez/, response.body)
  end

  test "does not list another account payments" do
    get payments_path

    assert_response :success
    assert_no_match(/Dueño Dos|other_account/, response.body)
  end

  test "cannot cancel a credit sale that has payments through the controller" do
    sale = sales(:one_credit)

    patch cancel_sale_path(sale)

    assert_redirected_to sale_path(sale)
    assert_match(/No se puede anular/, flash[ :alert ])
    assert sale.reload.completed?
  end

  test "shows the balance on a credit sale page" do
    sale = sales(:one_credit)

    get sale_path(sale)

    assert_response :success
    assert_match(/Saldo pendiente/, response.body)
    assert_match(/30.000/, response.body)
    assert_match(/Registrar pago/, response.body)
  end

  test "shows customer debt on the customer page" do
    customer = customers(:juan)

    get customer_path(customer)

    assert_response :success
    assert_match(/Cuenta corriente/, response.body)
    assert_match(/30.000/, response.body)
  end

  private

  def sign_in(user)
    post session_path, params: { email: user.email, password: "password123" }
  end
end