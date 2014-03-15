# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :restaurant do
    name "Wonton"
    address "39 4th Street Abhiramapuram Chennai"
    locality "Abhiramapuram"
    rating_editor_overall 2.5
    cost_for_two 600.0
    has_discount false
    created_at "2014-02-11 013014"
    updated_at "2014-02-11 084913"
    city nil
    latitude 11.2
    longitude 79.0
  end
end
