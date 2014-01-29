describe CustomZomato do
	context do
		let(:zomato) { CustomZomato.new }
		it "should make calls to zomato sucssfully" do
			zomato.has_city?("Chennai").should eq(true)
		end
	end
end