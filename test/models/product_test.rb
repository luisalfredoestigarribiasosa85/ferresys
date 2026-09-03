require "test_helper"

class ProductTest < ActiveSupport::TestCase
  setup do
    Current.account = accounts(:one)
  end

  teardown { Current.reset }

  test "creating a product with stock records an initial adjustment movement" do
    product = Current.account.products.build(
      name: "Nueva herramienta",
      sku: "NUE-1",
      price: 10_000,
      stock: 5,
      min_stock: 1
    )
    product.save!

    movement = product.stock_movements.last
    assert_equal "adjustment", movement.movement_type
    assert_equal 5, movement.quantity
    assert_equal 0, movement.previous_quantity
    assert_equal 5, movement.new_quantity
  end

  test "does not record a movement when created without initial stock" do
    product = Current.account.products.build(name: "Sin stock", price: 100, stock: 0)
    product.save!
    assert_empty product.stock_movements
  end

  test "low stock scope marks products at or below the minimum" do
    assert_includes Product.low_stock, products(:screwdriver)
    assert_not_includes Product.low_stock, products(:cement)
    assert_not_includes Product.low_stock, products(:inactive_tool)
  end

  test "scope of_account isolates other tenants" do
    assert_not_includes Product.of_account(accounts(:one)), products(:other_account_product)
  end

  test "sku uniqueness is scoped to the account" do
    duplicate = accounts(:two).products.build(sku: products(:cement).sku, name: "Otro")
    duplicate.save!

    other_dup = Current.account.products.build(sku: products(:cement).sku, name: "Duplicado")
    assert_not other_dup.valid?
    assert_includes other_dup.errors[:sku], "ya está en uso"
  end
end