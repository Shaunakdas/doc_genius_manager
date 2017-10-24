FactoryGirl.define do
  factory :user do
    first_name     { Faker::Name.first_name }
    last_name     { Faker::Name.last_name }
    email         { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    association :role, factory: :role
    mobile_number {[*('1'..'9')].sample(10).join}
    is_verified {true}
    verification_code {[*('1'..'9')].sample(6).join}
  end

end
