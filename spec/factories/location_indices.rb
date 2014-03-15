# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
    factory :location_index do
        city { FactoryGirl.create(:city) }
        restaurant_count 0
        latitude_a 12.79626
        latitude_b 12.81626
        latitude_c 12.79626
        latitude_d 12.81626
        longitude_a 80.07403699999999
        longitude_b 80.07403699999999
        longitude_c 80.09403699999999
        longitude_d 80.09403699999999

        factory :dummy_location_index do
            restaurant_count 0
            latitude_a 0
            latitude_b 0
            latitude_c 0
            latitude_d 0
            longitude_a 0
            longitude_b 0
            longitude_c 0
            longitude_d 0
        end
    end
end