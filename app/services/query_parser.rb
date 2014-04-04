class QueryParser	

	def initialize(query)

		@cities = City.all.pluck(:name)
		@cuisines = Restaurant.cuisine_counts.pluck(:name)
		@localities = LocationIndex.select(:locality).distinct.pluck(:locality)
		@query = {}

		@sentance = query

		['cities', 'localities', 'cuisines', 'rating', 'maximum_cost', 'discount_flag']
				.each { |type| send("initialize_#{type}!") }
	end

	def parsed_query
		@query
	end

private
	def has_word?(word)
		return false if word.nil?
		regexp = Regexp.new(word.downcase)
		@sentance.downcase.match(regexp).present?
	end

  ['cities', 'localities', 'cuisines'].each do |type|
    define_method "initialize_#{type}!" do
    	@query[type.to_sym] = eval("@#{type}").find_all { |word| has_word? word }
    end
  end

	def initialize_rating!
		@query[:rating]  = QueryParser
													.ratings
														.detect { |rating,words| 
																				rating if words.detect { |word| has_word? word } 
																		}
															.try(:first)
	end

	def initialize_maximum_cost!
		@query[:maximum_cost]  = QueryParser
																.cost_indicators
																	.detect { |cost,words| 
																							cost if	words.detect { |word| has_word? word } 
																					}
																		.try(:first)
	end

	def initialize_discount_flag!
		@query[:has_discount] = QueryParser
															.discount_indicators
																.detect { |word| has_word? word }
																	.present?
	end

	def self.ratings
		{
			5   => ["excellent"],
			4.5 => ["very good"],
			4   => ["very good"],
			3.5 => ["good"],
			3   => ["good"],
			2.5 => ["decent"],
			2   => ["decent"],
			1.5 => ["bad"],
			1   => ["bad"],
			0.5 => ["poor"],
			0   => ["poor"]
		}
	end

	def self.cost_indicators
		{
			500  => ["cheap"],
			1000 => ["economical"],
			2000 => ["costly"]
		}
	end

	def self.discount_indicators
		["discount","deal"]
	end

end