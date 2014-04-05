# Setting API call Timeout to 300, overriding default
module Twitter
  module REST
    class Client < Twitter::Client

      def connection_options
        @connection_options ||= {
          :builder => middleware,
          :headers => {
            :accept => 'application/json',
            :user_agent => user_agent,
          },
          :request => {
            :open_timeout => 10,
            :timeout => 300,
          },
        }
      end

    end
  end
end

class TwitterWrapper

	attr_reader :client

	def initialize

		@client = Twitter::REST::Client.new do |config|
		  config.consumer_key        = "2a3I8rR08wT6CGvbua7lOw"
		  config.consumer_secret     = "wIj2kMgJ6SnOuYtyM957lDgipmPEl4MAXs8Ua6QuZk"
		  config.access_token        = "104187890-Rf0OEYs3HVTTR6u4zmJrqn6aNN2sm1A11FO29gYD"
		  config.access_token_secret = "LKKUfrfhnswU3SLJDtGQvXdVvvuGSop62Ad9guqp8UAj0"
		end

	end
end