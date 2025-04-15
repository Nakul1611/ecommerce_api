class Product < ApplicationRecord
  belongs_to :category

  has_many :variants, dependent: :destroy

  validates :name, :price, presence: true
  accepts_nested_attributes_for :variants, allow_destroy: true

  validate :must_have_at_least_one_variant

  private

  def must_have_at_least_one_variant
    if product_variants.reject(&:marked_for_destruction?).empty?
      errors.add(:product_variants, "must have at least one variant")
    end
  end
end
