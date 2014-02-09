require_relative "../../app/services/custom_zomato.rb"
require "spec_helper"

describe CustomZomato do
	use_vcr_cassette "feed", :record => :new_episodes

	before(:all){
		@zomato = CustomZomato.new
	}	

	context "Instance Methods" do

		context "has_city" do
			it "should check if zomato supports a specified city" do
				VCR.use_cassette('has_city') do
				   @zomato.has_city?("Chennai").should eq(true)
				end
			end
		end

		context "city" do
			it "should return a zomato city Instance" do
				VCR.use_cassette('city') do
					@zomato.city("Chennai").localities.count.should eq(85)
				end
			end
		end

		context "all_restaurants_in" do
			before(:all){
				@number_of_restaurants = 0
			}

			it "should call a block over the list of all_restaurants_in in the specified city" do
				VCR.use_cassette('all_restaurants_in') do
					@zomato.all_restaurants_in("Chennai") do |restaurant|
						@number_of_restaurants = @number_of_restaurants.next
					end
					@number_of_restaurants.should eq(818)
				end				
			end

			it "should cache requests sent to zomato and not fetch the same data successively" do
				@zomato.updated?("Chennai").should eq(true)
			end

			it "should cache the number_of_restaurants_in a city" do
				@zomato.number_of_restaurants_in("Chennai").should eq(818)
			end

		end
	end

end