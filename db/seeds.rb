# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(email: 'email@example.com', password: 'password', password_confirmation: 'password')

Development.create!(
  [
    { application_number: 'AP/19/4173',
      site_address: 'Victor Road, Bermondsey, London, SE1 1TG',
      proposal: 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Cum sociis
      natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Lorem ipsum dolor sit amet,
      consectetur adipiscing elit. Cras justo odio, dapibus ac facilisis in, egestas eget quam.' },
    { application_number: 'AP/19/9275',
      site_address: 'Artillery Street, Camberwell, London, SE15 6TY',
      proposal: 'Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Praesent commodo cursus magna, vel
      scelerisque nisl consectetur et. Donec ullamcorper nulla non metus auctor fringilla. Donec sed odio dui.' }
  ]
)
