module Admin
  class VariantsController < ApplicationController
    before_action :set_product
    before_action :set_variant, only: [:show, :update, :destroy]

    def index
      render json: @product.variants
    end

    def show
      render json: @variant
    end

    def create
      variant = @product.variants.new(variant_params)
      if variant.save
        render json: variant, status: :created
      else
        render json: { errors: variant.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @variant.update(variant_params)
        render json: @variant
      else
        render json: { errors: @variant.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @variant.destroy
      head :no_content
    end

    private

    def set_product
      @product = Product.find(params[:product_id])
    end

    def set_variant
      @variant = @product.variants.find(params[:id])
    end

    def variant_params
      params.require(:variant).permit(:sku, :price_override, :stock, :size, :color, :is_active)
    end
  end
end
