# frozen_string_literal: true
require_relative 'modules'

class Station
  include InstanceCounter
  attr_reader :name
  attr_accessor :trains


  def initialize(name)
    @name = name
    puts "Станция #{name} создана!"
    @stations = []
    @stations << name
    @trains ||= []
    register_instance
  end

  def add_train(number)
    @trains << number
    puts "Поезд #{number} добавлен на станцию #{name}!"
  end

  def delete_train(number)
    if @trains.include? number
      @trains.delete(number)
      puts "Поезд #{number} удален со станции #{name}!"
    else
      puts "Поезда #{number} нет на станции #{name}!"
    end
  end

  def sort_by_type(type)
    @trains.select { |train| train.type == type}
  end

end

