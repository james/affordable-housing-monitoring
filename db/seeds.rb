# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(email: 'email@example.com', password: 'password', password_confirmation: 'password')

require 'csv'
CSV.read('data/registered_providers.csv').flatten.each do |registered_provider_name|
  RegisteredProvider.create!(name: registered_provider_name)
end

Development.without_auditing do
  Dwelling.without_auditing do
    100.times do
      app_year = Random.rand(2017...2019)
      number = Random.rand(5001...9999)
      app_number = "AP/#{app_year}/#{number}"
      proposal = Faker::Lorem.sentence(word_count: 7, supplemental: true, random_words_to_add: 7)
      streets = Faker::Address.street_name
      districts = [
        'Abbey Wood, SE2', 'Blackheath, SE3', 'Brockley, SE4', 'Camberwell, SE5', 'Catford, SE6',
        'Charlton, SE7', 'Deptford, SE8', 'Eltham, SE9', 'Greenwich, SE10', 'Kennington, SE11', 'Grove Park, SE12',
        'Lewisham, SE13', 'New Cross, SE14', 'Peckham, SE15', 'Rotherhithe, SE16', 'Walworth, SE17', 'Woolwich, SE18',
        'Norwood, SE19', 'Dulwich, SE21', 'East Dulwich, SE22', 'Forest Hill, SE23', 'Herne Hill, SE24',
        'South Norwood, SE25', 'Sydenham, SE26', 'West Norwood, SE27', 'Thamesmead, SE28'
      ]
      address = "#{streets}, #{districts.sample}"
      state = %w[draft agreed started completed].sample

      development = Development.create!(
        planning_applications: [PlanningApplication.new(application_number: app_number)],
        site_address: address,
        proposal: proposal,
        state: state
      )

      Random.rand(3...12).times do |i|
        Dwelling.create!(
          reference_id: "A#{i+1}",
          development_id: development.id,
          tenure: %w[open social intermediate].sample,
          habitable_rooms: Random.rand(2...4),
          bedrooms: Random.rand(1...2)
        )
      end
    end
  end
end
