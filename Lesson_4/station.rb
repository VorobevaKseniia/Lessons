class Station
  attr_accessor :trains, :station_name

  def initialize(station_name)
    @station_name = station_name
    @trains = []
  end

  def add_train(train_number)
    @trains << train_number
  end

  def delete_train(train_number)
    @trains.delete(train_number)
  end

  def trains_by_type(type)
    @trains.select {|train| train.type == type}
  end

end