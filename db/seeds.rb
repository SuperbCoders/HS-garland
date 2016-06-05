# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.where(email: 'hellohappystation@gmail.com').find_or_create_by(password: 'hellohspasswd')
User.where(email: 'corehook@gmail.com').find_or_create_by(password: 'corehook')


setting = Setting.general
if not setting.email_address
  setting.update_attributes(
      email_address: 'smtp.gmail.com',
      email_port: '587',
      email_domain: 'gmail.com',
      email_user_name: 'xyz@gmail.com',
      email_password: 'yourpassword',
      email_authentication: :plain,
      email_enable_starttls_auto: true,
      email_tls: true)
end
