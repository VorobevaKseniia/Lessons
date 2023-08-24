require_relative 'train'

class PassengerTrain < Train
  def initialize(speed = 0, train_number, type = "пассажирский", number_of_wagons)
    @train_number = train_number
    @type = type
    @number_of_wagons = number_of_wagons
    @speed = speed
  end
end
