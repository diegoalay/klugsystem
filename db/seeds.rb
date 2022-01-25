Account.find_or_create_by(name: 'Diego Alay')

u = User.find_or_create_by(email: "diego.alay.dev@gmail.com", account: Account.first)
u.password = "Hacker-123"
u.save!

puts "SEED EXECUTED"