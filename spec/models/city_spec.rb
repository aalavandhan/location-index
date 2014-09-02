require 'spec_helper'
describe City do 
	let(:city){ FactoryGirl.create(:city, :bounds => "12.806260:80.084037,13.1686612:80.3007453" )}
	context "Associations" do
		it { should have_many(:restaurants) }
	end

	context "bound_by" do
		it "should return city bounds as a array of coordinates" do
			city.bound_by.should eq([[12.806260,80.084037],[13.1686612,80.3007453]])
		end
	end
	context "max_latitude" do
		it "should return the max_latitude vlaue of the city bound" do
			city.max_latitude.should eq(13.1686612)
		end
	end
	context "max_longitude" do
		it "should return the max_longitude vlaue of the city bound" do
			city.max_longitude.should eq(80.3007453)
		end
	end
	context "min_latitude" do
		it "should return the min_latitude vlaue of the city bound" do
			city.min_latitude.should eq(12.806260)
		end		
	end
	context "min_longitude" do
		it "should return the min_longitude vlaue of the city bound" do
			city.min_longitude.should eq(80.084037)
		end
	end
	context "contains?" do
		it "should check if give latitude and longitude lie within the bounds of the city" do
			city.contains?(12.90260,80.185037).should eq(true)
		end
	end
end