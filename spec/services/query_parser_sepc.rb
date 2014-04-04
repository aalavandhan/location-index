require_relative "../../app/services/query_parser.rb"
require "spec_helper"

describe QueryParser do 
	before(:all){
		class MockActiveRecord
			attr_accessor :name
			def initialize(name)
				@name = name
			end
		end

		class Array
			def pluck(option)
				self.map{ |s| s.try(:name) }
			end

			def distinct
				self
			end
		end

	}

	before(:each){

		cities = [MockActiveRecord.new("Chennai"),MockActiveRecord.new("Bangalore")]
		cuisines = [MockActiveRecord.new("Italian"),MockActiveRecord.new("North Indian")]
		localities = [MockActiveRecord.new("Anna Nagar"),MockActiveRecord.new("Adyar")]
		
		City.stub(:all).and_return(cities)
		Restaurant.stub(:cuisine_counts).and_return(cuisines)
		LocationIndex.stub(:select).and_return(localities)

	}

	describe "#initialize_cities!" do
		let(:query_parser_1){ QueryParser.new("This is chennai") }
		let(:query_parser_2){ QueryParser.new("This is Bangalore") }
		let(:query_parser_3){ QueryParser.new("This is chennai and Bangalore") }
		let(:query_parser_4){ QueryParser.new("This is none") }
		it "should set @query[:cities] with the city names" do
			query_parser_1.instance_variable_get(:@query)[:cities].should eq(["Chennai"])
			query_parser_2.instance_variable_get(:@query)[:cities].should eq(["Bangalore"])
			query_parser_3.instance_variable_get(:@query)[:cities].include?("Chennai").should be_true
			query_parser_3.instance_variable_get(:@query)[:cities].include?("Bangalore").should be_true
			query_parser_4.instance_variable_get(:@query)[:cities].should be_empty
		end
	end

	describe "#initialize_localities!" do
		let(:query_parser_1){ QueryParser.new("This is adyar") }
		let(:query_parser_2){ QueryParser.new("This is anna nagar") }
		let(:query_parser_3){ QueryParser.new("This is adyar and anna nagar") }
		let(:query_parser_4){ QueryParser.new("This is none") }
		it "should set @query[:localities] with locality names" do
			query_parser_1.instance_variable_get(:@query)[:localities].should eq(["Adyar"])
			query_parser_2.instance_variable_get(:@query)[:localities].should eq(["Anna Nagar"])
			query_parser_3.instance_variable_get(:@query)[:localities].include?("Adyar").should be_true
			query_parser_3.instance_variable_get(:@query)[:localities].include?("Anna Nagar").should be_true
			query_parser_4.instance_variable_get(:@query)[:localities].should be_empty
		end
	end	

	describe "#initialize_cuisines!" do
		let(:query_parser_1){ QueryParser.new("This is italian") }
		let(:query_parser_2){ QueryParser.new("This is North indian") }
		let(:query_parser_3){ QueryParser.new("This is italian and North indian") }
		let(:query_parser_4){ QueryParser.new("This is none") }
		it "should set @query[:cities] with cuisine names" do
			query_parser_1.instance_variable_get(:@query)[:cuisines].should eq(["Italian"])
			query_parser_2.instance_variable_get(:@query)[:cuisines].should eq(["North Indian"])
			query_parser_3.instance_variable_get(:@query)[:cuisines].include?("Italian").should be_true
			query_parser_3.instance_variable_get(:@query)[:cuisines].include?("North Indian").should be_true
			query_parser_4.instance_variable_get(:@query)[:cuisines].should be_empty
		end
	end

	describe "#initialize_rating!" do
		let(:query_parser_1){ QueryParser.new("This is excellent") }
		let(:query_parser_2){ QueryParser.new("This is very good") }
		let(:query_parser_3){ QueryParser.new("This is good") }
		let(:query_parser_4){ QueryParser.new("This is decent") }
		let(:query_parser_5){ QueryParser.new("This is bad") }
		let(:query_parser_6){ QueryParser.new("This is none") }
		it "should set @query[:rating] with rating" do
			query_parser_1.instance_variable_get(:@query)[:rating].should eq(5)
			query_parser_2.instance_variable_get(:@query)[:rating].should eq(4)
			query_parser_3.instance_variable_get(:@query)[:rating].should eq(3)
			query_parser_4.instance_variable_get(:@query)[:rating].should eq(2)
			query_parser_5.instance_variable_get(:@query)[:rating].should eq(1)
			query_parser_6.instance_variable_get(:@query)[:rating].should be_nil
		end
	end

	describe "#initialize_maximum_cost!" do
		let(:query_parser_1){ QueryParser.new("This is cheap") }
		let(:query_parser_2){ QueryParser.new("This is economical") }
		let(:query_parser_3){ QueryParser.new("This is costly") }
		let(:query_parser_4){ QueryParser.new("This is none") }
		it "should set @query[:rating] with rating" do
			query_parser_1.instance_variable_get(:@query)[:maximum_cost].should eq(500)
			query_parser_2.instance_variable_get(:@query)[:maximum_cost].should eq(1000)
			query_parser_3.instance_variable_get(:@query)[:maximum_cost].should eq(2000)
			query_parser_4.instance_variable_get(:@query)[:maximum_cost].should be_nil
		end
	end

	describe "#initialize_discount_flag!" do
		let(:query_parser_1){ QueryParser.new("This is discount") }
		let(:query_parser_2){ QueryParser.new("This is deal") }
		let(:query_parser_3){ QueryParser.new("This is none") }
		it "should set @query[:has_discount] with discount flag" do
			query_parser_1.instance_variable_get(:@query)[:has_discount].should be_true
			query_parser_2.instance_variable_get(:@query)[:has_discount].should be_true
			query_parser_3.instance_variable_get(:@query)[:has_discount].should be_false
		end
	end	

end