# frozen_string_literal: true
require_relative 'wagons'

class PassengerWagons < Wagons

  def initialize(seats)
    @type = :passenger
    super
  end

  def occupy_seat
    @occupied += 1
  end

end
