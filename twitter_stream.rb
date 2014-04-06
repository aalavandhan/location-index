require "twitter"
require "curl"

class TwitterStream

	@@url = "http://localhost:3000/api/bot/tweet"
	@@admin_access_token = "EdAvEPVEC3LuaTg5Q3z6WbDVqZlcBQ8Z"

	def initialize
		@client = Twitter::Streaming::Client.new do |config|
		  config.consumer_key        = 	'2a3I8rR08wT6CGvbua7lOw'
		  config.consumer_secret     =  'wIj2kMgJ6SnOuYtyM957lDgipmPEl4MAXs8Ua6QuZk'
		  config.access_token        =  '104187890-Rf0OEYs3HVTTR6u4zmJrqn6aNN2sm1A11FO29gYD'
		  config.access_token_secret =  'LKKUfrfhnswU3SLJDtGQvXdVvvuGSop62Ad9guqp8UAj0'
		end
		@curl = CURL.new
	end	

	def filter array

		@client.filter(:track => array.join(",")) do |object|

			if object.is_a?(Twitter::Tweet)
				puts "New Tweet: #{object.text}"
				res_params = {
					:coordinates => object.geo.coordinates,
					:query => object.text,
					:username => "@"+object.user.screen_name,
					:admin_access_token => @@admin_access_token
				}
				puts "Resonse: "
				puts @curl.post(@@url,res_params)
			end

		end

	end

end
twitter_stream = TwitterStream.new
twitter_stream.filter(["ChennaiFoodie"])