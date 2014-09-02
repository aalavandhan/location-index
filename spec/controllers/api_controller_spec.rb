require 'spec_helper'

describe ApiController do

	describe "GET 'explore'" do
		before(:all){
			Restaurant.delete_all
			FactoryGirl.create(:restaurant)
		}

		context "invalid access token" do
			it "should return a json with success 0" do
				get "explore"
				resp = JSON.parse(response.body)
				resp['success'].should eq(0)
			end
		end

		context "valid access token" do
			it "should return all the restaurants as a json with success 1" do
				@access = AccessToken.generate_access_token
				get "explore", :access_token => @access.token
				resp = JSON.parse(response.body)
				resp['success'].should eq(1)
				resp['data'].should be_present
				resp['data']['restaurants'].should be_present
			end
		end
	end

	describe "GET 'location_query'" do
		before(:all){
			Restaurant.delete_all
			@restaurant = FactoryGirl.create(:restaurant)
		}
		before(:each){
			response = {
				:restaurants => [@restaurant],
				:step1 => true,
				:step2 => true,
				:step3 => true,
				:step4 => true
			}
			LocationIndex.stub(:fastest_nearest_search).and_return(response)
		}

		context "invalid access token" do
			it "should return a json with success 0" do
				get "location_query"
				resp = JSON.parse(response.body)
				resp['success'].should eq(0)
			end
		end

		context "valid access token" do
			it "should return all the restaurants as a json with success 1" do
				@access = AccessToken.generate_access_token
				get "location_query", :access_token => @access.token
				resp = JSON.parse(response.body)
				resp['success'].should eq(1)
				resp['data'].should be_present
				resp['data']['restaurants'].should be_present
				resp.keys.include?('step1').should be_true
				resp.keys.include?('step2').should be_true
				resp.keys.include?('step3').should be_true
				resp.keys.include?('step4').should be_true
			end
		end
	end

	describe "GET 'text_query'" do
		before(:all){
			Restaurant.delete_all
			FactoryGirl.create(:restaurant)
		}

		context "invalid access token" do
			it "should return a json with success 0" do
				get "text_query"
				resp = JSON.parse(response.body)
				resp['success'].should eq(0)
			end
		end

		context "valid access token" do
			before(:each){
				Restaurant.stub(:native_language_search).and_return(Restaurant.all)
			}
			it "should return all the restaurants as a json with success 1" do
				@access = AccessToken.generate_access_token
				get "text_query", :access_token => @access.token
				resp = JSON.parse(response.body)
				resp['success'].should eq(1)
				resp['data'].should be_present
				resp['data']['restaurants'].should be_present
			end
		end		
	end

	describe "POST 'tweet'" do
		before(:all){
			Restaurant.delete_all
			FactoryGirl.create(:restaurant)
		}

		context "invalid access token" do
			it "should return a json with success 0" do
				post "tweet"
				resp = JSON.parse(response.body)
				resp['success'].should eq(0)
			end
		end

		context "valid access token" do
			before(:each){
				class Client
					def update(text)
						"This #{text} is tweeted"
					end
				end
				TweetResponder.any_instance.stub(:respond).and_return("Tweet Text")
				TwitterWrapper.any_instance.stub(:client).and_return(Client.new)
			}
			context "when coordinates and cuisines are sent" do
				it "should create a response and tweet to the user" do
					post "tweet", :admin_access_token => ENV['ADMIN_ACCESS_TOKEN'], :username => "@nithinkrishh", :coordinates => "", :cuisines => ""
					assigns(:response).should eq("This Tweet Text is tweeted")
					resp = JSON.parse(response.body)
					resp['success'].should eq(1)
				end
			end

			context "when a query is sent" do
				it "should create a response and tweet to the user" do
					post "tweet", :admin_access_token => ENV['ADMIN_ACCESS_TOKEN'], :username => "@nithinkrishh", :query => ""
					assigns(:response).should eq("This Tweet Text is tweeted")
					resp = JSON.parse(response.body)
					resp['success'].should eq(1)
				end
			end

		end
	end	

end