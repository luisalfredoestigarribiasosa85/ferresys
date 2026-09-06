require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  setup do
    Current.account = accounts(:one)
    Current.user = users(:owner_one)
  end

  teardown { Current.reset }

  test "records a payment and reduces the sale balance" do
    sale = sales(:one_credit)
    assert_equal 30000, sale.balance

    payment = Current.account.payments.build(
      customer: sale.customer,
      sale: sale,
      amount: 10000,
      payment_method: :cash
    )

    assert payment.save
    assert_equal users(:owner_one), payment.user
    assert_equal 20000, sale.reload.balance
  end

  test "rejects a payment that exceeds the pending balance" do
    sale = sales(:one_credit)

    payment = Current.account.payments.build(
      customer: sale.customer,
      sale: sale,
      amount: 100000,
      payment_method: :cash
    )

    assert_not payment.save
    assert_includes payment.errors[:amount].to_s, "supera el saldo"
    assert_equal 30000, sale.reload.balance
  end

  test "rejects a payment for a cash sale" do
    sale = sales(:one_completed)

    payment = Current.account.payments.build(
      customer: sale.customer,
      sale: sale,
      amount: 1000,
      payment_method: :cash
    )

    assert_not payment.save
    assert_includes payment.errors[:sale].to_s, "crédito"
  end

  test "rejects a payment for a cancelled sale" do
    sale = sales(:one_cancelled)

    payment = Current.account.payments.build(
      customer: sale.customer,
      sale: sale,
      amount: 1000,
      payment_method: :cash
    )

    assert_not payment.save
    assert_includes payment.errors[:sale].to_s, "anulada"
  end

  test "rejects a payment that references another account sale or customer" do
    other_sale = sales(:other_account_credit)

    payment = Current.account.payments.build(
      customer: customers(:juan),
      sale: other_sale,
      amount: 1000,
      payment_method: :cash
    )

    assert_not payment.save
    assert_includes payment.errors[:sale].to_s, "pertenece a esta cuenta"
  end

  test "rejects a payment without amount" do
    sale = sales(:one_credit)

    payment = Current.account.payments.build(
      customer: sale.customer,
      sale: sale,
      amount: nil,
      payment_method: :cash
    )

    assert_not payment.save
    assert_includes payment.errors[:amount].to_s, "no es un número"
  end
end