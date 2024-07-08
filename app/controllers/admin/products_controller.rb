# app/controllers/admin/products_controller.rb
module Admin
  class ProductsController < Admin::BaseController
    before_action :set_product, only: [:show, :edit, :update, :destroy]

    def index
      @products = Product.paginate(page: params[:page], per_page: 10)
    end

    def show
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        redirect_to admin_product_path(@product), notice: 'Product was successfully created.'
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @product.update(product_params)
        redirect_to admin_product_path(@product), notice: 'Product was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @product.destroy
      redirect_to admin_products_path, notice: 'Product was successfully destroyed.'
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:title, :description, :price, :category_id, :weight, :status, :amount)
    end
  end
end
