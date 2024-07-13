module ApplicationHelper
  def show_add_to_cart(product, options = {})
    html_class = "btn btn-danger add-to-cart-btn"
    html_class += " #{options[:html_class]}" unless options[:html_class].blank?

    button_to shopping_carts_path, method: :post, params: { product_id: product.id, amount: 1 }, class: html_class do
      "<i class='fa fa-spinner'></i> Add to cart".html_safe
    end
  end
end
