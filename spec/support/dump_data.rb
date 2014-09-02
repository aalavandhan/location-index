class DumpData
	def self.sample_data(city)
		FactoryGirl.create(:restaurant,:city => city, :latitude => 0.01, :longitude => 0.01)
		FactoryGirl.create(:restaurant,:city => city, :latitude => 0.01, :longitude => 0.01)
		FactoryGirl.create(:restaurant,:city => city, :latitude => 0.01, :longitude => 0.01)
		FactoryGirl.create(:restaurant,:city => city, :latitude => 0.01, :longitude => 0.01)
		with_cusisine = FactoryGirl.create(:restaurant,:city => city, :latitude => 0.01, :longitude => 0.01)
		add_cusisine(with_cusisine,"North Indian")
		
		FactoryGirl.create(:restaurant,:city => city, :latitude => 0.03, :longitude => 0.01)
		FactoryGirl.create(:restaurant,:city => city, :latitude => 0.03, :longitude => 0.01)
		with_cusisine = FactoryGirl.create(:restaurant,:city => city, :latitude => 0.03, :longitude => 0.01)
		add_cusisine(with_cusisine,"North Indian")
	end

	private
		def self.add_cusisine(restaurant,cuisine)
			restaurant.cuisine_list.add(cuisine)
			restaurant.save!
		end
end