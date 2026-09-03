# Multi-tenant base concern. It assigns the current account to new records
# and exposes helpers to validate uniqueness per account.
module AccountScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :account

    scope :of_account, ->(account) { where(account: account) }
    scope :for_current_account, -> { where(account: Current.account) }

    before_validation :assign_account, on: :create
  end

  private

  def assign_account
    self.account ||= Current.account if Current.account
  end
end