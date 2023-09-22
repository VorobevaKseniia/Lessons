# frozen_string_literal: true
require_relative 'train'
class CargoTrain < Train
  include Valid
  attr_reader :type
  def initialize(number)
    super(number)
    @type = :cargo
    validate_!
  end

  def validate_!
    raise "Тип поезда не установлен!" if type != :passenger || type != :cargo
  end

end
