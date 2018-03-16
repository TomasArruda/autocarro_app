user = User.new
user.email = 'not_admin@gmail.com'
user.password = 'not_admin'
user.password_confirmation = 'not_admin'
user.save!

user = User.new
user.email = 'admin@gmail.com'
user.password = 'adminadmin'
user.password_confirmation = 'adminadmin'
user.admin = true
user.save!
