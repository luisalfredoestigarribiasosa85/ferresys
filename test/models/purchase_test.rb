require "test_helper"

class PurchaseTest < ActiveSupport::TestCase
  setup do
    Current.account = accounts(:one)
    Current.user = users(:owner_one)
  end

  teardown { Current.reset }

  test "creating a purchase increments stock, updates cost and registers a movement" do
    product = products(:cement)
    product.update!(stock: 10, cost_price: 70_000)

    purchase = Current.account.purchases.build(supplier: suppliers(:ferremax))
    purchase.items.build(product: product, quantity: 5, unit_cost: 100_000)
    purchase.save!

    product.reload
    assert_equal 15, product.stock
    assert_equal 80_000, product.cost_price
    assert_equal 500_000, purchase.total
    purchase_movement = Current.account.stock_movements.where(product: product, movement_type: :purchase).last
    assert_equal "Compra #{purchase.number}", purchase_movement.note
  end

  test "rejects purchase without supplier" do
    purchase = Current.account.purchases.build
    purchase.items.build(product: products(:cement), quantity: 1, unit_cost: 1000)

    assert_not purchase.save
    assert_includes purchase.errors.full_messages.to_s, "Proveedor"
  end

  test "rejects purchase without items" do
    purchase = Current.account.purchases.build(supplier: suppliers(:ferremax))

    assert_not purchase.save
    assert_includes purchase.errors.full_messages.to_s, "al menos un producto"
  end

  test "updates cost price with a weighted average of existing and new stock" do
    product = products(:cement)
    product.update!(stock: 10, cost_price: 5000)

    purchase = Current.account.purchases.build(supplier: suppliers(:ferremax))
    purchase.items.build(product: product, quantity: 10, unit_cost: 9000)
    purchase.save!

    # (10 * 5000 + 10 * 9000) / 20 = 7000
    assert_equal 7000, product.reload.cost_price.to_f
    assert_equal 20, product.reload.stock
  end
end
