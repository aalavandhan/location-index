require 'spec_helper'

describe AccessTokensController do

	describe "POST 'create'" do
		it "should create a new access_token and render json with token" do
			post "create"
			resp = JSON.parse(response.body)
			resp['success'].should eq(1)
			resp['data']['access_token']['token'].should be_present
		end
	end

end
