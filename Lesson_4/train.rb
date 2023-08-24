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

  def stop
    self.speed = 0
  end

  def hitch_wagon
      @number_of_wagons += 1 if @number_of_wagons > 0 && self.speed == 0
  end

  def unhitch_wagon
    @number_of_wagons -= 1 if @number_of_wagons > 0 && self.speed == 0
  end

  def assign_route(route)
    @route = route
    @current_station_index = 0
  end

  def next_station
    @route.stations[@current_station_index + 1]
  end

  def previous_station
    @route.stations[@current_station_index - 1]
  end

  def current_station
    @route.stations[@current_station_index]
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

end
