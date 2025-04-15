module Api::V1
  class OrdersController < ApplicationController
    before_action :authenticate_user!

    def index
      orders = current_user.orders.includes(order_items: :variant)
      render json: orders, include: { order_items: { include: :variant } }
    end

    def show
      order = current_user.orders.find(params[:id])
      render json: order, include: { order_items: { include: :variant } }
    end

    def create
      cart = current_user.cart
      if cart.cart_items.empty?
        return render json: { error: "Cart is empty" }, status: :unprocessable_entity
      end

      ActiveRecord::Base.transaction do
        order = current_user.orders.create!(
          address: order_params[:address],
          payment_method: order_params[:payment_method],
          total_price: 0 # we'll compute it
        )

        total = 0
        cart.cart_items.each do |item|
          price = item.variant.price_override || item.variant.product.price
          total += price * item.quantity

          order.order_items.create!(
            variant: item.variant,
            quantity: item.quantity,
            price: price
          )
        end

        order.update!(total_price: total)
        cart.cart_items.destroy_all

        render json: order, include: { order_items: { include: :variant } }, status: :created
      end
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    def order_params
      params.require(:order).permit(:address, :payment_method)
    end
  end
end
