account = Account.find_or_create_by(name: 'Klugsystem')

branch_office = account.branch_offices.find_or_create_by!(
  name: "Central",
  telephone: "43703704"
)

[
  {
    first_name: "Allan",
    first_surname: "Oneal",
    email: "allan.oneal"
  },
  {
    first_name: "Mafer",
    first_surname: "Brand",
    email: "mafer.bran"
  },
  {
    first_name: "Joanna",
    first_surname: "Perarla",
    email: "joanna.peralta"
  },
  {
    first_name: "Diego",
    first_surname: "Alay",
    email: "diego.alay"
  },
  {
    first_name: "Henry",
    first_surname: "Alay",
    email: "henry.alay"
  },
  {
    first_name: "Andrea",
    first_surname: "Alay",
    email: "andrea.alay"
  },
  {
    first_name: "Melany",
    first_surname: "Alay",
    email: "melany.alay"
  },
  {
    first_name: "Angelica",
    first_surname: "Alay",
    email: "angelica.alay"
  },
  {
    first_name: "Renato",
    first_surname: "Melendez",
    email: "renato.melendez"
  },
].each do |user|
  new_user = account.users.find_or_initialize_by(
    email: "#{user[:email]}@klugsystem.com"
  )

  new_user.first_name = user[:first_name]
  new_user.first_surname = user[:first_surname]
  new_user.password = "123456"
  new_user.branch_office = branch_office
  new_user.save!

  new_user.user_roles.create!(role_id: account.roles.first.id)
end

user = User.first

measurement_unit = account.measurement_units.find_or_create_by(name: 'UND')

(0..10).each do |n|
  account.products.create!(
    sku: Faker::Number.number(digits: 10).to_s,
    name: Faker::Food.dish,
    retail_price: rand(100),
    quantity: rand(30),
    user_creator: user,
    user_modifier: user,
    branch_office: branch_office,
    measurement_unit: measurement_unit,
    product_type: 'good'
  )
end

(0..20).each do |n|
  first_name = Faker::Name.first_name
  first_surname = Faker::Name.last_name

  account.clients.find_or_create_by!(
    billing_name: first_name + " " + first_surname,
    billing_email: Faker::Internet.email,
    billing_address: Faker::Address.country,
    billing_identifier: Faker::Number.number(digits: 7),
    first_name: first_name,
    first_surname: first_surname,
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
  user_modifier: user,
  status: true
)

account.payment_methods.find_or_create_by!(
  name: "tarjeta",
  interest_percentage: 5,
  interest_value: 50,
  user_creator: user,
  user_modifier: user,
  status: true
)

MenuItem.call

# account = Account.find_or_create_by(name: 'Transnunfio')
# [
#   {
#     first_name: "Diego",
#     first_surname: "Alay",
#     email: "diego.alay@transnunfio.com"
#   },
#   {
#     first_name: "Henry",
#     first_surname: "Alay",
#     email: "transnunfio@hotmail.com"
#   }
# ].each do |user|
#   new_user = account.users.find_or_initialize_by(
#     email: user[:email]
#   )

#   new_user.first_name = user[:first_name]
#   new_user.first_surname = user[:first_surname]
#   new_user.password = "123456"
#   new_user.save!
# end

puts "SEED EXECUTED"