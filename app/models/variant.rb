class Variant < ApplicationRecord
  belongs_to :product

  validates :sku, presence: true, uniqueness: true
  validates :stock, numericality: { greater_than_or_equal_to: 0 }

  def price
    price_override || product.price
  end
end
