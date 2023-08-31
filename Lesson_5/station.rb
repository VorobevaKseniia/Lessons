require_relative 'modules'

class Station
  include InstanceCounter
  attr_accessor :trains, :station_name, :stations

  @stations = []

  def initialize(station_name)
    @station_name = station_name
    @trains = []
    @stations << station_name
    register_instance
  end

  def self.all
    @stations
  end

  def add_train(number)
    @trains << number
  end

  def delete_train(number)
    @trains.delete(number)
  end

  def trains_by_type(type)
    @trains.select {|train| train.type == type}
  end

end
