# By using the symbol ':user', we get Factory Girl to simulate the User model
Factory.define :user do |user|
  user.name                     "Patrick Lindblom"
  user.email                    "patrick@lindblom.net"
  user.password                 "foobar"
  user.password_confirmation    "foobar"
end

