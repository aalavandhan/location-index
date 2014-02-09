require 'spec_helper'
describe City do 

	context "Associations" do
		it { should have_many(:restaurants) }
	end

end