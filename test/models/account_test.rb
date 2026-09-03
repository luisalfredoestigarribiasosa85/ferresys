require "test_helper"

class AccountTest < ActiveSupport::TestCase
  setup do
    @account = accounts(:one)
  end

  test "next_sale_number! hands out sequential numbers" do
    assert_equal 100, @account.next_sale_number!
    assert_equal 101, @account.next_sale_number!
    assert_equal 102, @account.reload.next_sale_number
  end

  test "user can authenticate with its password" do
    user = users(:owner_one)
    assert_equal user, user.authenticate("password123")
  end
end