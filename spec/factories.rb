FactoryBot.define do
  factory :planning_application do
    application_number { "MyString" }
    development { nil }
  end

  factory :registered_provider do
    name { 'RPName' }
  end

  factory :dwelling do
    tenure { 'open' }
    habitable_rooms { 1 }
    bedrooms { 1 }
    sequence(:reference_id) { |n| "A#{n}" }
    development
  end

  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :development do
    name { 'Development name' }
    application_number { 'AP/2019/1234' }
    site_address { '1 Site Address, London, SE1 1AA' }
    proposal { 'Build a building' }
    state { 'draft' }
  end
end
