require 'httparty'
require 'cgi'
require 'pry'

class TripPlanner
  attr_reader :user, :forecast, :recommendation, :api_result, :recommended_clothes, :clothes, :rec_accessories, :accessories
  attr_accessor :name, :destination, :duration, :min_temp, :max_temp   
  
  def initialize
    # Should be empty, you'll create and store @user, @forecast and @recommendation elsewhere
  end
  
  def plan

    @user = create_user
    @forecast = self.retrieve_forecast
    @recommendation = self.create_recommendation

     
 if @forecast != nil
   puts("Hey, #{@name}! I hope you enjoy your #{@duration} day trip to #{@destination}.\n Here is the forecast for your trip:")
     index = 1
     @forecast.each do |day|
        month = Time.new.strftime("%B")
        date = Time.new.strftime("%d").to_i
        if day.condition == "Clear"
          puts "On #{month} #{date + index} the skies will be #{day.condition.downcase}. The low will #{day.min_temp} and the high will be #{day.max_temp}."
        else
        puts "On #{month} #{date + index} there will be #{day.condition.downcase}. The low will #{day.min_temp} and the high will be #{day.max_temp}."
    end
        index +=1
   end

      puts "You should pack:"
      puts @recommended_clothes
      puts "Also, you may want to include these accessories:"
      puts @rec_accessories.sample
   else
      puts "I'm sorry, I don't have any weather information for #{@destination}."
    end
  
    end


    # # Plan should call create_user, retrieve_forecast and create_recommendation 
    # # After, you should display the recommendation, and provide an option to 
    # # save it to disk.  There are two optional methods below that will keep this
    # # method cleaner.
    #   @forecast = retrieve_forecast
    #     unless @forecast
    #     puts "City not found..."
    #     return nil
    #    end
 
  
  # def display_recommendation
  # end
  #
  # def save_recommendation

  # end
  
  def create_user
      puts "What is your name?"
      @name = gets.chomp.to_s
      puts "Where are you going?"
      @destination = gets.chomp.to_s.capitalize
      puts "What is the duration of your trip?"
      @duration = gets.chomp.to_i
        
      @user = User.new(name, destination, duration)
  
  end
  
  def call_api
     units = "imperial"
     options = "daily?q=#{CGI::escape(@user.destination)}&mode=json&units=#{units}&cnt=#{@user.duration}"
      url = "http://api.openweathermap.org/data/2.5/forecast/#{options}"
     @api_result = HTTParty.get(url)

     @api_result.is_a?(Hash) ? @api_result : JSON.parse(@api_result)
  end

  def parse_result

    # return nil if @api_result["cod"] = "404"

    # stripped_results = 
    
    if @api_result["cod"] == "200"
      @forecast = []
     index = 0
     while index < (@duration)
       min_temp = @api_result["list"][index]["temp"]["min"].floor
        max_temp = @api_result["list"][index]["temp"]["max"].ceil
        condition = @api_result["list"][index]["weather"][0]["main"]
      @forecast << Weather.new(min_temp, max_temp, condition)
      index += 1
     end
   else 
     @forecast = nil
    end
 end


  def retrieve_forecast
    self.call_api
    self.parse_result
    return @forecast
  end
  
  def collect_clothes
      @recommended_clothes = @forecast.map do |day|
        day.appropriate_clothing
      end
      return @recommended_clothes.uniq
    end
  

  def collect_accessories
    if @forecast != nil
    @rec_accessories = @forecast.map do |day|
      day.appropriate_accessories
    end
  return @rec_accessories.uniq
else 
  return nil
end
end

 def create_recommendation
      self.collect_clothes
     self.collect_accessories
     # return @recommendation
  end
end

class Weather
  attr_reader :min_temp, :max_temp, :condition, :recommended_clothes, :clothes, :rec_accessories, :accessories
  
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
    {
      min_temp: 60, max_temp: 70,
       recommendation: [
        "T-shirt", "oxford shirt", "jeans",
        "underwear", "baseball cap"
      ]
    },
    {
      min_temp: 70, max_temp: 90,
      suggestions: [
        "sandals", "flip-flops", "a swimsuit", "a tank top", "shorts", "capri pants"
      ]
    }
  ]

  ACCESSORIES = [
    {
      condition: "Rain",
      recommendation: [
        "galoshes", "umbrella"
      ]
    },
    {
      condition: "Clouds",
      recommendation: [
        "glasses", "a hoody"
      ]
    },
    {
      condition: "Clear",
      recommendation: [
        "sunglasses", "sunscreen", "a sun hat", "a picnic basket"
      ]
    },
    {
      condition: "Snow",
      recommendation: [
        "snow boots", "gloves", "a snow shovel"
      ]
    },
     {
      condition: "Drizzle",
      recommendation: [
        "rain jacket", "umbrella"
      ]
    },
  ]
  
  def initialize(min_temp, max_temp, condition)
      @min_temp = min_temp
      @max_temp = max_temp
      @condition = condition
  end
  
  def self.clothing_for(min_temp, max_temp)

  weather_range =  CLOTHES.select do |temp|
      avg_temp = (min_temp + max_temp) / 2
       avg_temp > temp[:min_temp]
       avg_temp < temp[:max_temp]
     # return rec[:recommendation].unique
    end
      weather_range[0][:recommendation]
  end
    # This is a class method, have it find the hash in CLOTHES so that the 
    # input temp is between min_temp and max_temp, and then return the 
    # recommendation.


  def self.accessories_for(condition)
    condition_match = ACCESSORIES.select do |weather|
        condition == weather[:condition]
         # return rec[:recommendation].unique
    end
         condition_match[0][:recommendation]

    # This is a class method, have it find the hash in ACCESSORIES so that
    # the condition matches the input condition, and then return the
    # recommendation.
  end
  
  def appropriate_clothing
    # @clothes = []
   @clothes = Weather.clothing_for(@min_temp, @max_temp)
   return @clothes.sample

  #  map
  # @clothes << Weather.clothing_for(@max_temp)
  #        return @clothes.uniq
        
    # Use the results of Weather.clothing_for(@min_temp) and 
    # Weather.clothing_for(@max_temp) to make an array of appropriate
    # clothing for the weather object.
    # You should avoid making the same suggestion twice... think
    # about using .uniq here
  end
  
  def appropriate_accessories
  @accessories = Weather.accessories_for(@condition)
    return @accessories
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
   def to_s
    puts "#{@name} is going to #{@destination} for #{@duration} days"
  end
  
end

trip_planner = TripPlanner.new
<<<<<<< HEAD
trip_planner.plan

Pry.start(binding)
=======
trip_planner.start
>>>>>>> af4c43786b24e1f6cb26834c0b74cd26e663ac47
