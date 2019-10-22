FactoryBot.define do
  factory :dwelling do
    tenure { 'open' }
    habitable_rooms { 1 }
    bedrooms { 1 }
    development
  end

  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :development do
    application_number { 'AP/2019/1234' }
    site_address { '1 Site Address, London, SE1 1AA' }
    proposal { 'Build a building' }
    state { 'draft' }
  end
end
