require_relative 'train'

class CargoTrain < Train
  def initialize(speed = 0, train_number, type = "грузовой", number_of_wagons)
    @train_number = train_number
    @type = type
    @number_of_wagons = number_of_wagons
    @speed = speed
  end
end