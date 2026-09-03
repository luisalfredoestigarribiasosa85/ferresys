class Product < ApplicationRecord
  include AccountScoped

  belongs_to :category, optional: true
  has_many :sale_items, dependent: :restrict_with_error
  has_many :stock_movements, dependent: :restrict_with_error

  validates :name, presence: true
  validates :sku, uniqueness: { scope: :account_id }, allow_blank: true
  validates :price, :cost_price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, :min_stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }
  scope :low_stock, -> { where("stock <= min_stock AND active = ?", true).order(:stock) }

  after_create :record_initial_stock, if: -> { stock.to_i.positive? }

  def low_stock?
    active? && stock <= min_stock
  end

  private

  def record_initial_stock
    stock_movements.create!(
      account: account,
      movement_type: :adjustment,
      quantity: stock,
      previous_quantity: 0,
      new_quantity: stock,
      note: "Stock inicial"
    )
  end
end