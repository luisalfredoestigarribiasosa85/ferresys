class StockMovement < ApplicationRecord
  include AccountScoped

  TYPES = %w[purchase sale adjustment return].freeze

  belongs_to :product
  belongs_to :sale, optional: true
  belongs_to :purchase, optional: true
  belongs_to :user, optional: true

  enum :movement_type, TYPES.each_with_index.to_h

  validates :quantity, numericality: { other_than: 0 }

  scope :recent, -> { order(created_at: :desc) }
  scope :sale_type, -> { where(movement_type: movement_types[:sale]) }

  def signed_quantity
    quantity.negative? ? quantity : "+#{quantity}"
  end
end