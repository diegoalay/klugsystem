Account.create(name: 'Diego Alay')

u = User.new(email: "diego.alay.dev@gmail.com", company: Company.first)
u.password = "Hacker-123"
u.save!

puts "SEED EXECUTED"