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
		  config.consumer_key        = "xnGybakbU03ZiAQLFjpEvVbxL"
		  config.consumer_secret     = "Py6Xhux10L9eQ1A4bXUlhz3lGcKuJTC5FTUKMmoxN1J8Y2jJ2f"
		  config.access_token        = "2432257214-oK61PuGcrtSAnkZgBLaXuxVOlPCUsl98BjgVQTV"
		  config.access_token_secret = "UHyLyr0CDh4lKs5f3NLTAWlaQoNOziYsOEKFZSwtADjPg"
		end

	end
end