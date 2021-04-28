task import_units: :environment do
  require 'csv'
  CSV.read('data/units.csv', headers: true).each do |row|
    p row['Internal unit ID']
    print "cannot find #{row['Name of RP']}" unless RegisteredProvider.find_by(name: row['Name of RP'])
    Dwelling.create!(
      development: nil,
      tenure: row['Single field tenure'],
      habitable_rooms: nil,
      bedrooms: row['No. of bedrooms'],
      address: "#{row['Flat/Unit No.']} #{row['Address']} #{row['Post code']}",
      registered_provider: RegisteredProvider.find_by!(name: row['Name of RP']),
      studio: false,
      rp_internal_id: row['Internal unit ID'],
      wheelchair_accessible: row['Wheelchair accessible'] == 'Yes',
      wheelchair_adaptable: row['Wheelchair adaptable'] == 'Yes',
      uprn: row['UPRN (if known)'],
    )
  end
end
