require 'faker'

ProductImage.destroy_all
Product.destroy_all
Category.destroy_all
Province.destroy_all
User.destroy_all
Address.destroy_all

console_category = Category.create!(title: "Console")
pc_category = Category.create!(title: "PC")

ps5_category = Category.create!(title: "PS5", parent: console_category)
xbox_category = Category.create!(title: "Xbox", parent: console_category)
switch_category = Category.create!(title: "Switch", parent: console_category)

headsets_category = Category.create!(title: "Headsets", parent: pc_category)
keyboards_category = Category.create!(title: "Keyboards and Mice", parent: pc_category)
chairs_category = Category.create!(title: "Gaming Chairs", parent: pc_category)

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

categories = [
  ps5_category,
  xbox_category,
  switch_category,
  headsets_category,
  keyboards_category,
  chairs_category
]

100.times do
  Product.create!(
    title: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 5),
    price: Faker::Commerce.price(range: 10..1000),
    msrp: Faker::Commerce.price(range: 10..1000),
    amount: Faker::Number.between(from: 1, to: 100),
    uuid: Faker::Number.unique.number(digits: 10),
    category: categories.sample,
    status: 'on'
  )
end

10.times do
  ActiveRecord::Base.transaction do
    user = User.new(
      email: Faker::Internet.email,
      password: 'password',
      password_confirmation: 'password',
      province: Province.all.sample
    )
    user.skip_default_address_validation = true

    if user.save
      address = Address.create!(
        user: user,
        address_type: 'billing',
        street: Faker::Address.street_address,
        city: Faker::Address.city,
        province: user.province,
        postal_code: Faker::Address.postcode,
        country: 'Canada'
      )

      user.update!(default_address: address)
    else
      puts "User could not be created: #{user.errors.full_messages.join(', ')}"
    end
  end
end

puts "Created #{Category.count} categories"
puts "Created #{Product.count} products"
puts "Created #{Province.count} provinces"
puts "Created #{User.count} users"
puts "Created #{Address.count} addresses"
