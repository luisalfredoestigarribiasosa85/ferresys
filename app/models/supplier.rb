class Supplier < ApplicationRecord
  include AccountScoped

  validates :name, presence: true
  validates :ruc, uniqueness: { scope: :account_id }, allow_blank: true
  normalizes :email, with: ->(email) { email&.strip&.downcase }
end