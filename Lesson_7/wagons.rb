# frozen_string_literal: true
require_relative 'modules'

class Wagons
  include Manufacturer
  attr_reader :type, :seats_volume, :occupied

  def initialize(seats_volume)
    @seats_volume = seats_volume
    @occupied = 0
  end

  def free
    @seats_volume - @occupied
  end
end
