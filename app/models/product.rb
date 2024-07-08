class Product < ApplicationRecord
  validates :category_id, presence: { message: "Category can't be blank" }
  validates :title, presence: { message: "Title can't be blank" }
  validates :status, inclusion: { in: ["on", "off"] , message: "Status must be on or off" }
  validates :amount, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "Amount must be an integer greater than or equal to 0" }
  validates :amount, presence: { message: "Amount can't be blank" },
    if: proc { |product| !product.amount.blank?}
  validates :msrp, presence: { message: "MSRP can't be blank" }
  validates :msrp, numericality: { greater_than_or_equal_to: 0, message: "MSRP must be greater than or equal to 0" },
    if: proc { |product| !product.msrp.blank?}
  validates :price, presence: { message: "Price can't be blank" }
  validates :price, numericality: { greater_than_or_equal_to: 0, message: "Price must be greater than or equal to 0" },
    if: proc { |product| !product.price.blank?}
  validates :description, presence: { message: "Description can't be blank" }

  belongs_to :category

  before_create :set_default_attrs

  private
  def set_default_attrs
    self.uuid = RandomCode.generate_product_uuid
  end
end
