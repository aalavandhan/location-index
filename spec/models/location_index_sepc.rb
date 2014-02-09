require 'spec_helper'
describe LocationIndex do

	before(:all){
		@location_index =  LocationIndex.create( coordinate_a: "13.0308689,80.254694", coordinate_b: "13.0308689,81.254694", coordinate_c: "14.0308689,80.254694", coordinate_d: "14.0308689,81.254694")
	}

	context "class_methods" do
		context "private" do

			context "range" do
				it "should take in a minimum maximum and interval and produce an array" do
					LocationIndex.instance_eval{ range(0,10,2) }.should eq([0,2,4,6,8,10])
				end			
			end

			context "to_string" do
				it "should take in a latitude and longitude and create a coordinate string" do
					LocationIndex.instance_eval{ to_string(13.0308689,80.254694) }.should eq("13.0308689,80.254694")
				end
			end

			context "to_array" do
				it "should take in a coordinate string and return latitude and longitude" do
					LocationIndex.instance_eval{ to_array("13.0308689,80.254694") }.should eq([13.0308689,80.254694])
				end
			end

			context "next_latitude" do
				it "should return the next_latitude in the latitude_range" do
					LocationIndex.instance_eval{ next_latitude(13.0308689) }.should eq(13.3058689)
				end
			end

			context "next_longitude" do
				it "should return the next_longitude in the longitude_range" do
					LocationIndex.instance_eval{ next_longitude(80.254694) }.should eq(80.339694)
				end
			end

		end
	end

	context "instance_methods" do

		context "center" do
			it "should return the geographic center of the two coordinates" do
				@location_index.center.should eq([13.5313651885272, 80.754694])
			end
		end

		context "latitude" do
			it "should take in a coordinate and return its latitude" do
				@location_index.latitude(:a).should eq(13.0308689)
			end
		end

		context "longitude" do
			it "should take in a coordinate and return its longitude" do
				@location_index.longitude(:a).should eq(80.254694)
			end
		end

		context "to_a" do
			it "should return the four coordinates as an array" do
				@location_index.to_a.should eq([
					[13.0308689, 80.254694],
					[13.0308689, 81.254694],
					[14.0308689, 80.254694],
					[14.0308689, 81.254694]
				])
			end
		end

	end
end