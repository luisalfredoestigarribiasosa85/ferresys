require "test_helper"

class SaleTest < ActiveSupport::TestCase
  setup do
    Current.account = accounts(:one)
    Current.user = users(:owner_one)
  end

  teardown { Current.reset }

  test "creating a sale decrements product stock and registers a movement" do
    product = products(:cement)
    product.update!(stock: 10)

    sale = Current.account.sales.build(customer: customers(:juan), payment_method: :cash)
    sale.items.build(product: product, quantity: 3, unit_price: 85000)
    sale.save!

    sale.reload
    assert_equal 7, product.reload.stock
    assert_equal(-3, Current.account.stock_movements.sale_type.where(sale: sale).sum(:quantity))
    assert_equal 255_000, sale.total
    assert_equal "000100", sale.number
    assert_equal 101, Current.account.reload.next_sale_number
  end

  test "rejects sale when stock is insufficient" do
    product = products(:cement)
    product.update!(stock: 2)

    sale = Current.account.sales.build(payment_method: :cash)
    sale.items.build(product: product, quantity: 5)

    assert_not sale.save
    assert_includes sale.errors.full_messages.to_s, "stock insuficiente"
    assert_equal 2, product.reload.stock
  end

  test "cancel restores stock and records a return movement" do
    product = products(:cement)
    product.update!(stock: 10)

    sale = Current.account.sales.build(payment_method: :cash)
    sale.items.build(product: product, quantity: 2, unit_price: 85000)
    sale.save!
    assert_equal 8, product.reload.stock

    sale.cancel!
    sale.reload

    assert sale.cancelled?
    assert_equal 10, product.reload.stock
    assert_equal 2, Current.account.stock_movements.where(sale: sale, movement_type: :return).sum(:quantity)
  end

  test "does not expose sales from another account through current account" do
    assert_empty Current.account.sales.where(id: sales(:other_account_sale).id)
  end
end