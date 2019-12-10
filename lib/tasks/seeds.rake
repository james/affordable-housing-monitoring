task reseed: :environment do
  AffordableHousingAudit.delete_all
  Dwelling.delete_all
  PlanningApplication.delete_all
  Development.delete_all
  RegisteredProvider.delete_all
  User.delete_all
  Rake::Task['db:seed'].invoke
end

task setup_quebec: :environment do
  require 'csv'
  development = Development.create!(
    name: 'Quebec Way',
    site_address: '24-28 QUEBEC WAY, LONDON, SE16 7LF',
    proposal: 'Demolition of existing building and redevelopment of site to provide a mixed-use building ranging from 4 to 7 storeys plus basement comprising 94 residential units (Use Class C3) and flexible commercial floorspace (Use Classes A1/A2/A3, B1, D1/D2); associated highway, public realm and landscaping works, car and cycle parking and associated works.',
    planning_applications: [PlanningApplication.new(application_number: '15/AP/2217')],
    developer: 'London Square Developments'
  )
  CSV.read("show_and_tell_data/quebec-p30.csv", headers: true).each do |dwelling_csv|
    Dwelling.create!(
      development: development,
      reference_id: dwelling_csv['Reference ID'],
      habitable_rooms: dwelling_csv['Habitable Rooms'],
      bedrooms: dwelling_csv['Bedrooms'],
      tenure: dwelling_csv['Tenure'],
      studio: dwelling_csv['Studio?'].present?,
      wheelchair_accessible: dwelling_csv['Wheelchair?'].present?,
    )
  end
  p development.id
end

task update_quebec: :environment do
  development = Development.find(ENV['DEVELOPMENT_ID'])
  development.agreed_on = '04 March 2016'.to_date
  development.state = 'agreed'
  development.save!
  pa = PlanningApplication.create!(development: development, application_number: '17/AP/2986')
  Audited.audit_class.as_user(User.first) do
    {
      'A-1-3' => {bedrooms: 3, habitable_rooms: 5, wheelchair_accessible: false},
      'A-2-6' => {bedrooms: 3, habitable_rooms: 5, wheelchair_accessible: false},
      'B-1-1' => {bedrooms: 3, habitable_rooms: 5, wheelchair_accessible: false},
      'B-2-1' => {bedrooms: 3, habitable_rooms: 5, wheelchair_accessible: false},
      'A-5-1' => {bedrooms: 1, habitable_rooms: 3},
      'A-5-2' => {bedrooms: 1, habitable_rooms: 2},
      'A-5-3' => {bedrooms: 1, habitable_rooms: 2},
    }.each_pair do |id, attrs|
      development.dwellings.find_by(reference_id: id).update!({audit_planning_application_id: pa.id, audit_comment: 'Unable to market wheelchair property'}.merge(attrs))
    end
    Dwelling.create!(development: development, tenure: 'open', reference_id: 'A-5-4', bedrooms: 3, habitable_rooms: 5, audit_planning_application_id: pa.id, audit_comment: 'Unable to market wheelchair property')
  end
end
