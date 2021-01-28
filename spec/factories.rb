FactoryBot.define do
  factory :scheme do
    name { 'Scheme name' }
    application_number { 'AP/2019/6789' }
    site_address { '2 Site Address, London, SE1 1AA' }
    proposal { 'Build several buildines' }
    developer { 'Developer Inc' }
  end

  factory :planning_application do
    application_number { 'AP/2019/1234' }
    development
  end

  factory :registered_provider do
    name { 'RPName' }
  end

  factory :dwelling do
    tenure { 'open' }
    habitable_rooms { 1 }
    bedrooms { 1 }
    sequence(:reference_id) { |n| "A#{n}" }
    studio { false }
    uprn { nil }
    development
  end

  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :development do
    name { 'Development name' }
    site_address { '1 Site Address, London, SE1 1AA' }
    proposal { 'Build a building' }
    state { 'draft' }

    transient do
      planning_applications_count { 1 }
    end

    after(:build) do |dwelling, evaluator|
      evaluator.planning_applications_count.times do
        dwelling.planning_applications << build(:planning_application, development: nil)
      end
    end

    factory :development_with_number do
      transient do
        application_number { 'AP/2019/1234' }
        planning_applications_count { 0 }
      end
      after(:build) do |dwelling, evaluator|
        dwelling.planning_applications << build(:planning_application, development: nil, application_number: evaluator.application_number)
      end
    end
  end
end
