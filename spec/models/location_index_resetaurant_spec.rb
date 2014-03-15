require 'spec_helper'
describe LocationIndexRestaurant do

	context "assosiations" do
		it { should belong_to(:location_index) }
		it { should belong_to(:restaurant) }
	end
end