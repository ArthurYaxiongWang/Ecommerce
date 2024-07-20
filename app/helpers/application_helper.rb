module ApplicationHelper
  def show_add_to_cart(product, options = {})
    html_class = "btn btn-danger add-to-cart-btn"
    html_class += " #{options[:html_class]}" unless options[:html_class].blank?

    button_to shopping_carts_path, method: :post, params: { product_id: product.id, amount: 1 }, class: html_class do
      "<i class='fa fa-spinner'></i> Add to cart".html_safe
    end
  end

  def calculate_taxes(total_price, province_name)
    rates = tax_rates[province_name]
    pst = total_price * rates[:pst]
    gst = total_price * rates[:gst]
    hst = total_price * rates[:hst]

    { pst: pst, gst: gst, hst: hst }
  end

  def tax_rates
    {
      'Alberta' => { pst: 0.0, gst: 0.05, hst: 0.0 },
      'British Columbia' => { pst: 0.07, gst: 0.05, hst: 0.0 },
      'Manitoba' => { pst: 0.07, gst: 0.05, hst: 0.0 },
      'New Brunswick' => { pst: 0.0, gst: 0.0, hst: 0.15 },
      'Newfoundland and Labrador' => { pst: 0.0, gst: 0.0, hst: 0.15 },
      'Nova Scotia' => { pst: 0.0, gst: 0.0, hst: 0.15 },
      'Ontario' => { pst: 0.0, gst: 0.0, hst: 0.13 },
      'Prince Edward Island' => { pst: 0.0, gst: 0.0, hst: 0.15 },
      'Quebec' => { pst: 0.09975, gst: 0.05, hst: 0.0 },
      'Saskatchewan' => { pst: 0.06, gst: 0.05, hst: 0.0 },
      'Northwest Territories' => { pst: 0.0, gst: 0.05, hst: 0.0 },
      'Nunavut' => { pst: 0.0, gst: 0.05, hst: 0.0 },
      'Yukon' => { pst: 0.0, gst: 0.05, hst: 0.0 }
    }
  end
end
