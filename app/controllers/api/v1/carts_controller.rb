module Api::V1
  class CartsController < ApplicationController
    before_action :authenticate_user!

    def show
      render json: current_user.cart, include: { cart_items: { include: :product_variant } }
    end
  end
end
