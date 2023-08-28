require_relative 'wagons'

class PassengerWagons < Wagons
  def initialize
    @type = :passenger
  end
end