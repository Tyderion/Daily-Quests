require 'faker'

FactoryGirl.define do
  factory :hero do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.email { "#{f.first_name}.#{f.last_name}@test.ch" }
    f.password "foobar"
    f.password_confirmation "foobar"
  end
end
