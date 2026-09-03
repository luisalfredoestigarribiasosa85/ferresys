class Customer < ApplicationRecord
  include AccountScoped

  has_many :sales, dependent: :nullify

  validates :name, presence: true
  validates :document_number, uniqueness: { scope: :account_id }, allow_blank: true
  normalizes :email, with: ->(email) { email&.strip&.downcase }
end