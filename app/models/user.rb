class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable, :validatable, :confirmable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_one :cart, dependent: :destroy
  after_create :create_cart

  has_many :orders, dependent: :destroy
end
