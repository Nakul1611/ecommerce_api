class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items

  STATUSES = %w[pending paid shipped cancelled].freeze

  validates :status, inclusion: { in: STATUSES }

  before_validation :set_default_status

  private

  def set_default_status
    self.status ||= "pending"
  end
end
