# frozen_string_literal: true
require_relative 'train'
class PassengerTrain < Train
  include Valid
  attr_reader :type
  def initialize(number)
    super(number)
    @type = :passenger
    validate_!
  end
  def validate_!
    raise "Тип поезда не установлен! '#{type.class}''#{type.inspect}'!" if type != :passenger || type != :cargo
  end
end
