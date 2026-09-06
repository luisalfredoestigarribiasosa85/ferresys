class Customer < ApplicationRecord
  include AccountScoped

  has_many :sales, dependent: :nullify
  has_many :payments, dependent: :destroy

  validates :name, presence: true
  validates :document_number, uniqueness: { scope: :account_id }, allow_blank: true
  normalizes :email, with: ->(email) { email&.strip&.downcase }

  # Open credit sales (still have a pending balance) for this customer.
  def open_credit_sales
    sales.completed.credit.select { |s| s.balance.positive? }
  end

  # Total outstanding debt across all open credit sales.
  def total_debt
    open_credit_sales.sum(&:balance)
  end
end