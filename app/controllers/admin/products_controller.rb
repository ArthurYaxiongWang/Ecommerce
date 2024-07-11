class Admin::ProductsController < Admin::BaseController
  before_action :find_product, only: [:edit, :update, :destroy]

  def index
    @products = Product.page(params[:page] || 1).per(params[:per_page] || 10).order(id: "desc")
  end

  def new
    @product = Product.new
    @root_categories = Category.roots
  end

  def create
    @product = Product.new(params.require(:product).permit!)
    @root_categories = Category.roots
    if @product.save
      flash[:notice] = "Product created successfully!"
      redirect_to admin_products_path
    else
      render action: :new
    end
  end

  def edit
    @root_categories = Category.roots
    render action: :new
  end

  def update
    @product.attributes = params.require(:product).permit!
    @root_categories = Category.roots
    if @product.save
      flash[:notice] = "Product updated successfully!"
      redirect_to admin_products_path
    else
      render action: :new
    end
  end

  def destroy
    if @product.destroy
      flash[:notice] = "Product deleted successfully!"
      redirect_to admin_products_path
    else
      flash[:notice] = "Product can't be deleted!"
      redirect_to :back
    end
  end

  private
  def find_product
    @product = Product.find(params[:id])
  end
end
