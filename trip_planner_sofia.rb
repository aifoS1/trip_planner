require 'httparty'
require 'cgi'
require 'pry'


class TripPlanner
	attr_accessor :city, :days, :url 
	attr_reader :trips, :user, :forecast, :recommendation
   def initialize()
   	# @city = destination
   	# @days= days
   	# @trips = {0}
   end

   def plan(user, forecast, recommendation)
     @user =user
     @user_hash =Hash.new{0}
     @forecast = Hash.new{0}
     @recommendation = recommendation

     # puts "The forecast will be: #{@forecast}.\nI would recommend you pack #{recommendation}."
   end

   
    def create_user
    	puts "What is your name?"
    	name = gets.chomp.to_s
    	puts "Where are you going?"
    	destination = gets.chomp.to_s
    	puts "What is the duration of your trip?"
    	days = gets.chomp.to_i
        
        User.new(name, destination, days)
    	 
    end

   def remember_trip(trip)
   	  @trips.push(trip)
   end
   
   def self.trips
   	  @trips
   end

   def call_api
 	 units = "imperial" # you can change this to metric if you prefer
     options = "daily?q=#{CGI::escape(city)}&mode=json&units=#{units}&cnt=#{days}"
     @url = "http://api.openweathermap.org/data/2.5/forecast/#{options}"
   end

   def parse_result(url)
   	     JSON.parse(@url)
   end

    def retrieve_forecast
   	   
   end

end

class User
   attr_accessor :city, :days, :name
   def initialize(name, city, days)
   	@name = name
   	@city = city
   	@days = days
   end

   def User_hash(name, city, days)
      @user_hash[name] +=
     
   end

  end
  Pry.start(binding)

trip_planner = TripPlanner.new
  trip_planner.plan