require_relative 'train'

class CargoTrain < Train
  attr_reader :type

  def initialize(train_number)
    @type = :cargo
    super
  end
end
