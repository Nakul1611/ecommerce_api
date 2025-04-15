module Api::V1
  class CartItemsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_cart

    def create
      item = @cart.cart_items.find_or_initialize_by(variant_id: cart_item_params[:variant_id])
      item.quantity += cart_item_params[:quantity].to_i
      if item.save
        render json: item, include: :variant, status: :created
      else
        render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      item = @cart.cart_items.find(params[:id])
      if item.update(cart_item_params)
        render json: item, include: :variant
      else
        render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      item = @cart.cart_items.find(params[:id])
      item.destroy
      head :no_content
    end

    private

    def set_cart
      @cart = current_user.cart
    end

    def cart_item_params
      params.require(:cart_item).permit(:variant_id, :quantity)
    end
  end
end
