require 'faker'

Product.destroy_all
Category.destroy_all
Province.destroy_all
User.destroy_all

image_path = Rails.root.join('db', 'seeds', 'images', 'default_image.png')

parent_categories = []
2.times do |i|
  parent_categories << Category.create!(title: "Parent Category #{i + 1}")
end

categories = []
4.times do |i|
  categories << Category.create!(title: "Category #{i + 1}", parent: parent_categories.sample)
end

provinces = [
  { name: 'Alberta' },
  { name: 'British Columbia' },
  { name: 'Manitoba' },
  { name: 'New Brunswick' },
  { name: 'Newfoundland and Labrador' },
  { name: 'Nova Scotia' },
  { name: 'Ontario' },
  { name: 'Prince Edward Island' },
  { name: 'Quebec' },
  { name: 'Saskatchewan' },
  { name: 'Northwest Territories' },
  { name: 'Nunavut' },
  { name: 'Yukon' }
]

provinces.each do |province|
  Province.create!(province)
end

100.times do
  product = Product.create!(
    title: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 5),
    price: Faker::Commerce.price(range: 10..1000),
    msrp: Faker::Commerce.price(range: 10..1000),
    amount: Faker::Number.between(from: 1, to: 100),
    uuid: Faker::Number.unique.number(digits: 10),
    category: categories.sample,
    status: 'on'
  )

  if File.exist?(image_path)
    product.image.attach(io: File.open(image_path), filename: 'default_image.png')
  else
    puts "Image file not found: #{image_path}"
  end
end

10.times do
  User.create!(
    email: Faker::Internet.email,
    password: 'password',
    password_confirmation: 'password',
    address: Faker::Address.street_address,
    province: Province.all.sample
  )
end

puts "Created #{Category.count} categories"
puts "Created #{Product.count} products"
puts "Created #{Province.count} provinces"
puts "Created #{User.count} users"
