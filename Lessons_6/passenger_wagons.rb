# frozen_string_literal: true
require_relative 'wagons'
class PassengerWagons < Wagons
  def initialize
    @type = :passenger
  end

end
