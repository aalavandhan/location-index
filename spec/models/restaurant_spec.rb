require 'spec_helper'
describe Restaurant do 

	context "Associations" do
		it { should belong_to(:city) }
	end

	context "Instance methods" do
		before(:each){
			@city = City.create(:name => "Chennai")
			@restaurant = Restaurant.create(
				:name => "Wonton",
				:address => "39, 4th Street, Abhiramapuram, Chennai", 
				:locality => "Abhiramapuram", 
				:rating_editor_overall => 2.5,
				:cost_for_two => 600.0,
				:has_discount => false,
				:latitude => 13.0308689,
				:longitude => 80.254694,
				:city_id => @city.id
			)
		}
		context "coordinates" do
			it "should return a coordinate string" do
				@restaurant.coordinates.should eq("13.0308689,80.254694")
			end
		end
	end

end