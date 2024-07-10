require 'faker'

# Clear existing data
Product.destroy_all
Category.destroy_all

# Create a directory path for the images
image_path = Rails.root.join('db', 'seeds', 'images', 'default_image.png')

# Create parent categories
parent_categories = []
2.times do |i|
  parent_categories << Category.create!(title: "Parent Category #{i + 1}")
end

# Create subcategories with parent categories
categories = []
4.times do |i|
  categories << Category.create!(title: "Category #{i + 1}", parent: parent_categories.sample)
end

# Create 100 products, distributed across the 4 categories
100.times do
  product = Product.create!(
    title: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 5),
    price: Faker::Commerce.price(range: 10..1000),
    msrp: Faker::Commerce.price(range: 10..1000),
    amount: Faker::Number.between(from: 1, to: 100),
    uuid: Faker::Number.unique.number(digits: 10),
    category: categories.sample,
    status: 'on' # Ensure status is set to 'on'
  )

  # Attach an image to the product using ActiveStorage
  if File.exist?(image_path)
    product.image.attach(io: File.open(image_path), filename: 'default_image.png')
  else
    puts "Image file not found: #{image_path}"
  end
end

puts "Created #{Category.count} categories"
puts "Created #{Product.count} products"
