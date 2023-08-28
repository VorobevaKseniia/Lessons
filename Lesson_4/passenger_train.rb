require_relative 'train'

class PassengerTrain < Train
  attr_reader :type

  def initialize(train_number)
    @type = :passenger
    super
  end
end