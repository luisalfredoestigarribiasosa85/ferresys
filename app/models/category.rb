class Category < ApplicationRecord
  include AccountScoped

  has_many :products, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :account_id }
end