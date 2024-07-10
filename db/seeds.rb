require 'faker'

# Clear existing data
Product.destroy_all
Category.destroy_all

# Create 4 categories
categories = []
4.times do |i|
  categories << Category.create!(title: "Category #{i + 1}")
end

# Create 100 products, distributed across the 4 categories
100.times do
  Product.create!(
    title: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 5),
    price: Faker::Commerce.price(range: 10..1000),
    msrp: Faker::Commerce.price(range: 10..1000),
    amount: Faker::Number.between(from: 1, to: 100),
    uuid: Faker::Number.unique.number(digits: 10),
    category: categories.sample,
    status: 'on' # Ensure status is set to 'on'
  )
end

puts "Created #{Category.count} categories"
puts "Created #{Product.count} products"
