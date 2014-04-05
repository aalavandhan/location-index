require 'spec_helper'

describe AccessToken do

  describe "#valid for" do

  	it "should return the time in seconds the token is valid for" do
  		AccessToken.valid_for.should eq(36000)
  	end

  end

  describe "#expire" do

  	let(:access_token){ FactoryGirl.create(:access_token) }
  	it "should expire the access token" do
  		access_token.expire!
  		access_token.should be_expired
  	end

  end

  describe "#expires_at" do

  	let(:access_token){ FactoryGirl.create(:access_token) }
  	before(:each){
  		AccessToken.any_instance.stub(:created_at).and_return(Time.at(0))
  	}
  	it "should expire the access token" do
  		access_token.expires_at.should eq(Time.at(36000))
  	end

  end

  describe "valid_now?" do

  	context "when access_token is not valid_now" do
  		let(:access_token){ FactoryGirl.create(:access_token) }
	  	before(:each){
  			AccessToken.any_instance.stub(:created_at).and_return(Time.at(0))
  		}
  		it "should return false" do
  			access_token.should_not be_valid_now
  		end
  	end

  	context "when access_token is valid_now" do
  		let(:access_token){ FactoryGirl.create(:access_token) }
  		it "should return true" do
  			access_token.should be_valid_now
  		end
  	end

  end

  describe "#self.generate_access_token" do
  	it "should generate a new access_token" do
  		count = AccessToken.count
  		AccessToken.generate_access_token
  		AccessToken.count.should eq(count + 1)
  	end
  end

  describe "#expire_all_invalid!" do
  	
  	before(:all){
  		AccessToken.delete_all
  		AccessToken.generate_access_token
  	}
  	context "after create" do
  		before(:each){
  			AccessToken.any_instance.stub(:created_at).and_return(Time.at(0))	
  		}
  		it "should check all the access_token for validity and expire if invalid" do
  			AccessToken.generate_access_token
  			AccessToken.first.should_not be_valid_now
  			AccessToken.last.should_not be_valid_now
  		end
  	end

  end

end
