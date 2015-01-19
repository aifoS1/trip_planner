require 'httparty'
require 'cgi'
require 'pry'

class TripPlanner
  attr_reader :user, :forecast, :recommendation, :api_result 
  attr_accessor  :name, :destination, :duration, :min_temp, :max_temp
  
  def initialize
    # Should be empty, you'll create and store @user, @forecast and @recommendation elsewhere
  end
  
  def plan

    @user = @create_user
    @forecast = @retrieve_forecast
    @recommendation = @create_recommendation
    # # Plan should call create_user, retrieve_forecast and create_recommendation 
    # # After, you should display the recommendation, and provide an option to 
    # # save it to disk.  There are two optional methods below that will keep this
    # # method cleaner.
    #   @forecast = retrieve_forecast
    #     unless @forecast
    #     puts "City not found..."
    #     return nil
    #    end
  end
  
  # def display_recommendation
  # end
  #
  # def save_recommendation
     # rec_hash = {0}
     # rec_hash << tipinfo
  # end
  
  def create_user
      puts "What is your name?"
      name = gets.chomp.to_s
      puts "Where are you going?"
      destination = gets.chomp.to_s.capitalize
      puts "What is the duration of your trip?"
      duration = gets.chomp.to_i
        
        @user = User.new(name, destination, duration)
    # provide the interface asking for name, destination and duration
    # then, create and store the User object
  end
  
  def retrieve_forecast

    
    
    #parsing result for mintemp, maxtemp, and condition\
day = []
     # @forecast 
 @user.duration.times do
  index = 0
       new_day = @forecast.each do |day|
               day.each do |x|
                   x
              end
          end

          parse = new_day.each do |y|
              y.each do |z|
                z
              end
            end

        day.push(Weather.new(parse[0][0], parse[0][1], parse[0][2]))
           index +=1
      end
puts day
    # index =0
    # while index < @user.duration do |day|
    #    min_temp = @api_result["list"][index]["temp"]["min"]
    #    max_temp =  @api_result["list"][index]["temp"]["max"]
    #    condition =  @api_result["list"][index]["weather"][0]["main"]
     
    #  #pushing min,max,condition into @forecast array
    # @forecast = []
    #  @forecast << min_temp
    #  @forecast << max_temp
    #  @forecast << condition
   
    #  new_trip = Weather.new(min_temp, max_temp, condition)
    #  new_trip
     # puts "#{min_temp} #{max_temp} #{condition}"
     # puts "#{@forecast}"
    # use HTTParty.get to get the forecast, and then turn it into an array of
    # Weather objects... you  might want to institute the two methods below
    # so this doesn't get out of hand...
  end
  
   def call_api
     units = "imperial"
     options = "daily?q=#{CGI::escape(@user.destination)}&mode=json&units=#{units}&cnt=#{@user.duration}"
     @url = "http://api.openweathermap.org/data/2.5/forecast/#{options}"
     @api_result = HTTParty.get(@url)
  
  end
  # #
  def parse_result
    @forecast = []
   index = 0
     while index < (@user.duration)
      day = []
      day_min_temp = @api_result["list"][index]["temp"]["min"]
      day_max_temp = @api_result["list"][index]["temp"]["max"]
      day_description = @api_result["list"][index]["weather"][0]["main"]
      day.push(day_min_temp, day_max_temp, day_description)
      # day = Weather.new(day)

      @forecast << day
      index += 1
     end

     puts @forecast
 end
  
  def create_recommendation
     # @recommendation = 

     # if @min_temp == CLOTHES[0][:suggestions]

    # once you have the forecast, ask each Weather object for the appropriate
    # clothing and accessories, store the result in @recommendation.  You might
    # want to implement the two methods below to help you kee this method
    # smaller...
  end
  
  def collect_clothes
     
  end
  #
  # def collect_accessories
  # end
end

class Weather
  attr_reader :min_temp, :max_temp, :condition 
  
  # given any temp, we want to search CLOTHES for the hash
  # where min_temp <= temp and temp <= max_temp... then get
  # the recommendation for that temp.
  CLOTHES = [
    {
      min_temp: -50, max_temp: 0,
      recommendation: [
        "insulated parka", "long underwear", "fleece-lined jeans",
        "mittens", "knit hat", "chunky scarf"
      ]
    },
    {
      min_temp: 0, max_temp: 35,
       recommendation: [
        "insulated parka", "long underwear", "fleece-lined jeans",
        "mittens", "knit hat", "chunky scarf"
      ]

    },
    {
      min_temp: 35, max_temp: 50,
       recommendation: [
        "down jacket", "flannel shirt", "jeans",
        "mittens", "knit hat", "scarf", "underwear"
      ]

    },
     {
      min_temp: 50, max_temp: 60,
       recommendation: [
        "light jacket", "flannel shirt", "jeans",
        "underwear", "baseball cap",
      ]

    },
  ]

  ACCESSORIES = [
    {
      condition: "Rainy",
      recommendation: [
        "galoshes", "umbrella"
      ]
    }
  ]
  
  def initialize(min_temp, max_temp, condition)
      @min_temp = min_temp
      @max_temp = max_temp
      @condition = condition
  end
  
  def self.clothing_for(temp)

    return 
    # This is a class method, have it find the hash in CLOTHES so that the 
    # input temp is between min_temp and max_temp, and then return the 
    # recommendation.
  end
  
  def self.accessories_for(condition)
    # This is a class method, have it find the hash in ACCESSORIES so that
    # the condition matches the input condition, and then return the
    # recommendation.
  end
  
  def appropriate_clothing
    # Use the results of Weather.clothing_for(@min_temp) and 
    # Weather.clothing_for(@max_temp) to make an array of appropriate
    # clothing for the weather object.
    # You should avoid making the same suggestion twice... think
    # about using .uniq here
  end
  
  def appropriate_accessories
    # Use the results of Weather.accessories_for(@condition) to make
    # an array of appropriate accessories for the weather object.
    # You should avoid making the same suggestion twice... think
    # about using .uniq here
  end
end

class User
  attr_reader :name, :destination, :duration
  
  def initialize(name, destination, duration)
    @name = name
    @destination = destination
    @duration = duration
  end

  
end

trip_planner = TripPlanner.new
trip_planner.plan

Pry.start(binding)
