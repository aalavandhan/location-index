class AccessToken < ActiveRecord::Base

	after_create :expire_all_invalid!

	def expire!
		update(:expired => true)
	end

	def increment_used_count!
		update(:used_count => used_count + 1)
	end

	def expires_at
		Time.at(created_at.to_i + AccessToken.valid_for)
	end

	def valid_now?
		!expired? and (expires_at.to_i > Time.now.to_i) and used_count < AccessToken.max_use_count
	end
	
	def self.generate_access_token
		random_string = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
		create(:token => random_string)
	end	

private

	def expire_all_invalid!
		AccessToken.all.each do |access_token|
			unless access_token.valid_now?
				access_token.expire!
			end
		end
	end

	def self.valid_for
		#In seconds
		36000
	end	

	def self.max_use_count
		1000
	end	

end
