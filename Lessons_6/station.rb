# frozen_string_literal: true
require_relative 'modules'

class Station
  include InstanceCounter
  include Valid
  attr_reader :name
  attr_accessor :trains


  def initialize(name)
    @name = name
    @stations = []
    @stations << name
    @trains ||= []
    register_instance
    validate!
  end

  def add_train(number)
    @trains << number
  end

  def delete_train(number)
    @trains.include? number
    @trains.delete(number)
  end

  def sort_by_type(type)
    @trains.select { |train| train.type == type}
  end

  private

  def validate!
    raise "Название станции не может быть пустым!" if name.length < 1
  end
end

