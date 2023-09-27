# frozen_string_literal: true

require_relative 'wagons'

class CargoWagons < Wagons
  def initialize(volume)
    @type = :cargo
    super
  end

  def occupy_volume(volume)
    @occupied += volume
  end
end
