require "test_helper"

class StockAdjustTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:owner_one))
  end

  test "adjusts product stock and records an adjustment movement" do
    product = products(:cement)
    assert_equal 20, product.stock

    assert_difference "StockMovement.count", 1 do
      patch adjust_stock_product_path(product), params: { product: { stock: 25, note: "Conteo físico" } }
    end

    assert_redirected_to product_path(product)
    assert_match(/Stock ajustado de 20 a 25/, flash[ :notice ])
    assert_equal 25, product.reload.stock

    movement = StockMovement.where(product: product, movement_type: :adjustment).last
    assert_equal 5, movement.quantity
    assert_equal 20, movement.previous_quantity
    assert_equal 25, movement.new_quantity
    assert_equal "Conteo físico", movement.note
  end

  test "reduces stock when the physical count is lower" do
    product = products(:cement)

    patch adjust_stock_product_path(product), params: { product: { stock: 17 } }

    assert_redirected_to product_path(product)
    assert_equal 17, product.reload.stock
    assert_equal(-3, StockMovement.where(product: product, movement_type: :adjustment).last.quantity)
  end

  test "does not create a movement when stock is unchanged" do
    product = products(:cement)

    assert_no_difference "StockMovement.count" do
      patch adjust_stock_product_path(product), params: { product: { stock: 20 } }
    end

    assert_redirected_to product_path(product)
    assert_match(/sin cambios/, flash[ :notice ])
  end

  test "cannot set a negative stock" do
    product = products(:cement)

    assert_no_difference "StockMovement.count" do
      patch adjust_stock_product_path(product), params: { product: { stock: -3 } }
    end

    assert_redirected_to product_path(product)
    assert_match(/no puede ser negativo/, flash[ :alert ])
  end

  test "shows the quick adjust form on the product page" do
    get product_path(products(:cement))

    assert_response :success
    assert_match(/Ajuste rápido de stock/, response.body)
    assert_match(/Nuevo stock/, response.body)
  end

  private

  def sign_in(user)
    post session_path, params: { email: user.email, password: "password123" }
  end
end