require 'spec_helper'
describe LocationIndex do

	before(:all){
		@location_index =  LocationIndex.create( 
			latitude_a:  13.0308689,
			longitude_a: 80.254694,
			latitude_b:  13.0308689,
			longitude_b: 81.254694,
			latitude_c:  14.0308689,
			longitude_c: 80.254694,
			latitude_d:  14.0308689,
			longitude_d: 81.254694
		)
	}

	context "assosiations" do
		it { should belong_to(:city) }
		it { should have_many(:restaurants).through(:location_index_restaurants) }
	end

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
					LocationIndex.instance_eval{ next_latitude(13.0308689) }.should eq(13.0508689)
				end
			end

			context "next_longitude" do
				it "should return the next_longitude in the longitude_range" do
					LocationIndex.instance_eval{ next_longitude(80.254694) }.should eq(80.274694)
				end
			end

		end
	end

	context "instance_methods" do

		context "contains?" do
			it "should check if a coordinate lies within the zone marked by the four coordinates" do
				@location_index.contains?(@location_index.center).should eq(true)
			end
		end

		context "center" do
			it "should return the geographic center of the two coordinates" do
				@location_index.center.should eq([13.5313651885272, 80.754694])
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

		context "private_methods" do
			context "start_point" do
				it "should return the start_point point of the zone marked by the four coordinates" do
					@location_index.instance_eval{ start_point }.should eq([13.0308689, 80.254694])
				end
			end

			context "end_point" do
				it "should return the end_point point of the zone marked by the four coordinates" do
					@location_index.instance_eval{ end_point }.should eq([14.0308689, 81.254694])
				end
			end
		end
	end

end