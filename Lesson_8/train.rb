# frozen_string_literal: true

require_relative 'modules'

class Train
  include Manufacturer
  include InstanceCounter
  include Valid

  STANDARD_NUMBER = /\A\w{3}-*\w{2}\z/.freeze

  attr_reader :number, :type, :route, :stations
  attr_accessor :speed, :wagons, :current_station_index

  def self.find(number)
    @trains.find { |train| train.number == number ? train : nil }
  end

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
    register_instance
    validate!
  end

  def each_wagon(&block)
    wagons.each_with_index { |wagon, index| block.call(wagon, index) }
  end

  def hitch_wagon(wagon)
    @wagons << wagon if speed.zero? && wagon.type == type
  end

  def unhitch_wagon(wagon)
    if wagons.any?
      @wagons.delete(wagon) if speed.zero? && wagon.type == type
    else
      puts 'У этого поезда нет вагонов нет!'
    end
  end

  def add_route(route)
    @route = route
    @current_station_index = 0
    route.stations[current_station_index].add_train self
  end

  def current_station
    @route.stations[@current_station_index]
  end

  def go_next_station
    current_station.delete_train self
    @current_station_index += 1 if next_station
    current_station.add_train self
  end

  def go_previous_station
    current_station.delete_train self
    @current_station_index -= 1 if previous_station
    current_station.add_train self
  end

  private

  def validate!
    raise 'Номер не может быть пустым!' if number == ''
    raise 'Номер не совпадает с форматом!' if number !~ STANDARD_NUMBER
  end

  def next_station
    @route.stations[@current_station_index + 1]
  end

  def previous_station
    @route.stations[@current_station_index - 1]
  end
end
