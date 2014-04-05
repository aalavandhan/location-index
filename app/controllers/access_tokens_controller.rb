class AccessTokensController < ApplicationController
	def create
		@access_token = AccessToken.generate_access_token
		respond_with_CRUD_json_response(@access_token)
	end
end
