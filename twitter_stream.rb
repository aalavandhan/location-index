require "twitter"
require "curl"

class TwitterStream

	@@url = "http://localhost:3000/api/bot/tweet"
	@@admin_access_token = "EdAvEPVEC3LuaTg5Q3z6WbDVqZlcBQ8Z"

	def initialize
		@client = Twitter::Streaming::Client.new do |config|
		  config.consumer_key        = "xnGybakbU03ZiAQLFjpEvVbxL"
		  config.consumer_secret     = "Py6Xhux10L9eQ1A4bXUlhz3lGcKuJTC5FTUKMmoxN1J8Y2jJ2f"
		  config.access_token        = "2432257214-oK61PuGcrtSAnkZgBLaXuxVOlPCUsl98BjgVQTV"
		  config.access_token_secret = "UHyLyr0CDh4lKs5f3NLTAWlaQoNOziYsOEKFZSwtADjPg"
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