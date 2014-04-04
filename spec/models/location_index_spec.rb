require 'spec_helper'
describe LocationIndex do

	before(:all){
		#@city = DumpData.initialize_test_database
	}

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

		context "latitude" do
			it "should return the latitude of geographic center" do
				@location_index.latitude.should eq(13.5313651885272)
			end
		end

		context "longitude" do
			it "should return the longitude of geographic center" do
				@location_index.longitude.should eq(80.754694)
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

	context "search algorithm" do

		before(:all){
			@new_city = FactoryGirl.create(:city,:bounds =>"0.01:0.01,0.02:0.02")
			@ranges = [[0.0, 0.02], [0.0, 0.02]]
			DumpData.sample_data(@new_city)
			LocationIndex.index(@new_city.id)
			LocationIndex.first.update(:full_address => "this is adyar")
		}

		context "#self.index" do

			context "#self.create_zones_for" do
				context "#self.zone_dimensions_for" do
					it "should return a range of latitude and longitude based on city's bounds" do
						LocationIndex.zone_dimensions_for(@new_city.id).should eq(@ranges)
					end
				end

				it "should create location_index based on the city's bounds" do
					@new_city.location_indices.count.should eq(4)
				end
			end

			context "#populate" do
				it "should populate each location_index with restaurants" do
					LocationIndex.populate(@new_city.id)
					@new_city.location_indices.first.restaurants.count.should eq(5)
				end
			end

			context "#self.update_restaurant_count" do
				it "should add restaurant count for each location_index" do
					@new_city.location_indices.maximum(:restaurant_count).should eq(5)
				end
			end
		end

		context "#self.locate" do
			context "given a latitude and longitude" do
				it "should return a location_index object within which the coordinates lie" do
					LocationIndex.locate(@new_city.location_indices.first.center,@new_city.id).should eq(@new_city.location_indices.first)
				end
				it "should return nil if no such object lies" do
					LocationIndex.locate([-100,-100]).should be_nil
				end
			end
			context "given nil" do
				it "should return nil" do
					LocationIndex.locate([nil,nil]).should be_nil
					LocationIndex.locate(nil).should be_nil
				end
			end
		end

		context "#self.locate_by_locality" do
			context "given a locality name" do
				it "should return a location_index object in which the locality lies" do
					LocationIndex.locate_by_locality("adyar").should be_present
				end				
				it "should return nil if no such location_index is present" do
					LocationIndex.locate_by_locality("a").should be_nil
					LocationIndex.locate_by_locality("testtest").should be_empty
				end
			end
			context "given nil" do
				it "should return nil" do
					LocationIndex.locate_by_locality(nil).should be_nil
				end
			end
		end

		context "#near_by" do
			it "should return the zones around the given location_index" do
				@new_city.location_indices.first.near_by.count.should eq(3)
				@new_city.location_indices.last.near_by.count.should eq(3)
			end
		end

		context "#self.fastest_nearset_search" do

			context "#self.initialize_query" do
				it "should return a query object" do
					@query = LocationIndex.initialize_query
					@query[:restaurants].should_not be_nil
					@query[:errors].should_not be_nil
					@query[:step1].should_not be_nil
					@query[:step2].should_not be_nil
					@query[:step3].should_not be_nil
					@query[:step4].should_not be_nil
				end
			end

			context "#restaurants_in_zone" do
				context "restaurants are not present in the zone" do
					before(:all){
						@query = LocationIndex.initialize_query
						location_index = @new_city.location_indices.last
						@result = location_index.restaurants_in_zone(@query,nil,10)
					}
					it "should set step1 as false" do
						@result[:step1].should eq(false)
					end
					it "should return an empty array" do
						@result[:restaurants].should eq([])
					end
				end

				context "restaurants are present in the zone" do
					before(:all){
						@query = LocationIndex.initialize_query
						location_index = @new_city.location_indices.first
						@result = location_index.restaurants_in_zone(@query,nil,10)
					}
					it "should set step1 as true" do
						@result[:step1].should eq(true)
					end
					it "should return an array of restaurants" do
						@result[:restaurants].count.should eq(5)
					end
				end

				context "tags are given (North Indian)" do
					before(:all){
						@query = LocationIndex.initialize_query
						location_index = @new_city.location_indices.first
						@result = location_index.restaurants_in_zone(@query,["North Indian"],10)	
					}
					it "should set step1 as true" do
						@result[:step1].should eq(true)
					end
					it "should return an array of North Indian restaurants" do
						@result[:restaurants].first.cuisine_list.include?("North Indian")
					end
				end

				context "limit is specified" do
					before(:all){
						@query = LocationIndex.initialize_query
						location_index = @new_city.location_indices.first
						@result = location_index.restaurants_in_zone(@query,nil,2)	
					}
					it "should return limited number of restaurants" do
						@result[:restaurants].count.should eq(2)
					end
				end
			end

			context "#restaurants_in_near_by_zones" do
				context "when restaurants are present" do
					before(:all){
						@query = LocationIndex.initialize_query
						location_index = @new_city.location_indices.first
						@result = location_index.restaurants_in_near_by_zones(@query,nil,10)
					}
					it "should return an array of restaurants in near_by zones" do
						@result[:restaurants].count.should eq(3)
					end
					it "should return step2 as true" do
						@result[:step2].should be_true
					end
				end

				context "when restaurants are not present" do
					before(:each){
						@query = LocationIndex.initialize_query
						location_index = @new_city.location_indices.first
						LocationIndex.any_instance.stub(:near_by).and_return(LocationIndex.where(:id => 0))
						@result = location_index.restaurants_in_near_by_zones(@query,nil,10)
					}
					it "should return an empty array" do
						@result[:restaurants].count.should eq(0)
					end
					it "should return step2 as false" do
						@result[:step2].should be_false
					end
				end
			end

		end

	end

end