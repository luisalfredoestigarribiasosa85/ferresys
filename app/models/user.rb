class User < ApplicationRecord
  ROLES = %w[owner employee].freeze

  belongs_to :account
  has_many :sales, foreign_key: :user_id, dependent: :nullify
  has_many :stock_movements, foreign_key: :user_id, dependent: :nullify

  has_secure_password

  enum :role, ROLES.each_with_index.to_h

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { scope: :account_id },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, allow_nil: true

  def owner?
    role == "owner"
  end
end