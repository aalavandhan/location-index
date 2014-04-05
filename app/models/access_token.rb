class AccessToken < ActiveRecord::Base

	after_create :expire_all_invalid!

	def self.valid_for
		#In seconds
		36000
	end

	def expire!
		update(:expired => true)
	end

	def expires_at
		Time.at(created_at.to_i + AccessToken.valid_for)
	end

	def valid_now?
		!expired? and (expires_at.to_i > Time.now.to_i)
	end
	
	def self.generate_access_token
		random_string = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
		create(:token => random_string)
	end	

private

	def expire_all_invalid!
		AccessToken.all.each do |access_token|
			access_token.expire! unless access_token.valid_now?
		end
	end	

end
