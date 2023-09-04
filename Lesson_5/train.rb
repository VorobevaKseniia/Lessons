require_relative 'modules'

class Train
  include Manufacturer
  include InstanceCounter
  attr_reader  :type, :number, :wagons, :route
  attr_accessor :speed, :trains

  @@trains = []

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    @@trains << number
    register_instance

  end

  def self.find(number)
    @@trains.find { |train| train.number == number ? train : nil }
  end

  def up_speed(s)
    self.speed += s
  end

  def stop
    self.speed = 0
  end


  def hitch_wagon(wagon)
    @wagons << wagon if speed.zero? && wagon.type == type
  end

  def unhitch_wagon(wagon)
    @wagons.delete(wagon) if speed.zero? && wagon.type == type
  end

  def current_station
    @route.stations[@current_station_index]
  end

  def assign_route(route)
    @route = route
    @current_station_index = 0
    route.stations[0].add_train(self)
  end

  def go_next_station
    current_station.delete_train(self)
    @current_station_index += 1 if next_station
    current_station.add_train(self)
  end

  def go_previous_station
    current_station.delete_train(self)
    @current_station_index -= 1 if previous_station
    current_station.add_train(self)
  end

  private  # Используются только в этом классе
  def next_station
    @route.stations[@current_station_index + 1]
  end

  def previous_station
    @route.stations[@current_station_index - 1]
  end

end
