require_relative 'modules'

class Route
  include InstanceCounter
  attr_accessor :stations
  attr_reader :first_station, :last_station

  def initialize(first_station, last_station)
    @@stations = [first_station, last_station]
    register_instance
  end

  def add_station(station)
    @@stations.insert(-2, station) # !-2!
  end

  def delete_station(station)
    @@stations.delete(station) if station != first_station && station != last_station
  end

end
