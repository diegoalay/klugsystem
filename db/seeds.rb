account = Account.find_or_create_by(name: 'Diego Alay')

account.users.find_or_create_by(
  first_name: "Mafer",
  first_surname: "Brand",
  email: "mafer@klugsystem.com",
  account: account
)

user.password = "123456"
user.save!

user = account.users.find_or_create_by(
  first_name: "Diego",
  first_surname: "Alay",
  email: "diego.alay@klugsystem.com",
  account: account
)

user.password = "123456"
user.save!

user = account.users.find_or_create_by(
  first_name: "Allan",
  first_surname: "Oneal",
  email: "allan@klugsystem.com",
  account: account
)

user.password = "123456"
user.save!

branch_office = account.branch_offices.find_or_create_by!(
  name: "Central",
  telephone: "43703704",
  user_creator: user,
  user_modifier: user
)

(0..500).each do |n|
  account.products.create!(
    sku: Faker::Number.number(digits: 10).to_s,
    name: Faker::Food.dish,
    retail_price: rand(100),
    quantity: rand(30),
    user_creator: user,
    user_modifier: user,
    branch_office: branch_office
  )
end

(0..20).each do |n|
  account.clients.find_or_create_by!(
    first_name: Faker::Name.first_name,
    first_surname: Faker::Name.last_name,
    user_creator: user,
    user_modifier: user
  )
end

(0..20).each do |n|
  account.employees.find_or_create_by!(
    first_name: Faker::Name.first_name,
    first_surname: Faker::Name.last_name,
    user_creator: user,
    user_modifier: user
  )
end

account.payment_methods.find_or_create_by!(
  name: "efectivo",
  user_creator: user,
  user_modifier: user
)

account.payment_methods.find_or_create_by!(
  name: "tarjeta",
  interest_percentage: 5,
  interest_value: 50,
  user_creator: user,
  user_modifier: user
)

puts "SEED EXECUTED"