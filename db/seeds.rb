User.create!(email: 'email@example.com', password: 'password', password_confirmation: 'password')

require 'csv'
CSV.read('data/registered_providers.csv').flatten.each do |registered_provider_name|
  RegisteredProvider.create!(name: registered_provider_name)
end

[
  {
    name: 'Elephant Park MP2 "West Grove" Plot H2',
    application_number: '14/AP/3438',
    site_address: 'PLOT H2 WEST GROVE WITHIN LAND BOUNDED BY PLOT H1 OF THE ELEPHANT PARK MASTERPLAN TO THE NORTH, PLOT H7 OF THE ELEPHANT PARK MASTER TO THE EAST, HEYGATE STREET TO THE SOUTH AND WALWORTH ROAD TO THE WEST',
    proposal: 'Application for approval of reserved matters (access, scale, appearance, layout and landscaping) for Plot H2 within Elephant Park (previously referred to as the Heygate Masterplan), submitted pursuant to the Outline Planning Permission ref: 12/AP/1092. The proposals comprise the construction of a development plot ranging between 10 and 31 storeys in height (max height 104.8m AOD) comprising 365 residential units, 2,033sqm (GEA) flexible retail (A1-A5) uses, car parking, cycle storage, servicing, plant areas, landscaping, new public realm and other associated works.',
  },
  {
    name: 'Elephant Park MP3 "Park Central" Plot H4',
    application_number: '17/AP/1489',
    site_address: 'The Heygate Estate And Surrounding Land Bound By New Kent Road (A201) To The North Rodney Place And Rodney Road To The East Wansey Street To The South And Walworth Road (A215) And Elephant Road To The West. London SE17',
    proposal: 'Details of the number of wheelchair accessible dwellings in plot H4 pursuant to paragraph 29.2 of Schedule 3 of the Section 106 agreement attached to planning permission ref 12/AP/1092 (Outline application for: Redevelopment to provide a mixed use development comprising a number of buildings ranging between 13.13m (AOD) and 104.8m (AOD) in height with capacity for between 2,300 (min) and 2,469 (max) residential units together with retail (Class A1-A5), business (Class B1), leisure and community (Class D2 and D1), energy centre (sui generis) uses. New landscaping, park and public realm, car parking, means of access and other associated works).',
  },
  {
    name: '19AP1612',
    application_number: '19/AP/1612',
    site_address: 'St Olaves Nursing Home, Ann Moss Way, London',
    proposal: 'Demolition of the existing buildings on site (a derelict single storey nursing home and porta-cabins) and construction of two buildings (Building A - Part 4/Part 5/Part 6 storey building fronting onto Lower Road, Building B ¿ Part 3 /Part 4 storey building fronting on to Ann Moss Way) providing 61 residential units (19 x 1-bedroom, 26 x 2-bedroom and 16 x 3-bedroom) together with 2 wheelchair parking spaces and associated landscaping.',
  }
].each do |development_hash|
  development = Development.create!(
    name: development_hash[:name],
    site_address: development_hash[:site_address],
    proposal: development_hash[:proposal],
    planning_applications: [PlanningApplication.new(application_number: development_hash[:application_number])]
  )
  CSV.read("data/#{development_hash[:name]}.csv", headers: true).each do |dwelling_csv|
    Dwelling.create!(
      development: development,
      reference_id: dwelling_csv['Reference ID'],
      habitable_rooms: dwelling_csv['Habitable Rooms'],
      bedrooms: dwelling_csv['Bedrooms'],
      tenure: dwelling_csv['Tenure'],
    )
  end
end
