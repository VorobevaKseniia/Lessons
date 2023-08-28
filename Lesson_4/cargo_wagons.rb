require_relative 'wagons'

class CargoWagons < Wagons
  def initialize
    @type = :cargo
  end
end