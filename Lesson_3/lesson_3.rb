class Station
  attr_accessor :trains
  def initialize(station_name)
    @station_name = station_name
  end
  def add_train(train_number)
    @trains << train_number
  end
  def show_trains
    @trains.each { |train| puts train.train_number }
  end
  def show_trains_type
    i = 0
    y = 0
    @trains.each do |train|
      if train.type == "грузовой"
        i += 1
      else
        y += 1
      end
      puts train.type
    end
    puts "Количество грузовых поездов #{i}"
    puts "Количество пассажирских поездов #{y}"
  end
end

class Route
  attr_accessor :stations
  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @stations = [@first_station, @last_station]

  end
=begin
  def add_station(station)
    self.stations = self.stations.delete(-1)
    self.stations << station << @last_station
    puts self.stations
  end
=end
  def delete_station(station)
    @stations.delete(station)
    puts @stations
  end

  def stations
    @stations.each { |value| puts value }
  end
end

class Train
  attr_reader  :type
  attr_accessor :speed, :train_number, :number_of_wagons
  def initialize(speed = 0, train_number, type, number_of_wagons)
    @train_number = train_number
    @type = type
    @number_of_wagons = number_of_wagons
    @speed = speed
  end
  def up_speed(s)
    self.speed += s
  end
  def speed
    puts self.speed
  end
  def stop
    self.speed = 0
  end
  def number_of_wagons
    self.number_of_wagons
  end
  def hitch_unhitch_wagon(s)
    if self.speed == 0
      self.number_of_wagons += s  #если число будет отрицательным количество уменьшится
    else
      puts "Невозможно, поезд движется!"
    end
  end
  def route
    #route = @stations
    #puts route
  end
  def location

  end
end
new_station = Route.new("академическая", "лесная")
new_station.stations
new_station.add_station("мужество")
new_route = Train.new("3819", "грузовой", 3)
#new_route.route