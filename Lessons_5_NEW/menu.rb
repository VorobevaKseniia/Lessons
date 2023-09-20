# frozen_string_literal: true
require_relative 'station'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagons'
require_relative 'passenger_wagons'
require_relative 'cargo_wagons'
require_relative 'route'
require_relative 'modules'
class Menu

  attr_accessor :stations, :trains, :routes, :wagons

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def open_menu
    loop do
      puts "Выберите пунк от 1 до 10"
      puts "01. Создать новую станцию"
      puts "02. Создать поезд"
      puts "03. Создать маршрут и управлять станциями в нем (добавлять, удалять)"
      puts "4.Назначить маршрут поезду"
      puts "05. Добавить вагон к поезду"
      puts "06. Отцепить вагон от поезда"

      puts "7.Переместить поезд по маршруту вперед и назад"

      puts "8.Просмотреть список станций и список поездов на станции"
      puts "09. Выход"
      puts "10. Отладка"

      choice = gets.chomp.to_i
      case choice
      when 1
       create_station
      when 2
        create_train
      when 3
        route_acts
      when 4
        assign_route
      when 5
        add_wagon
      when 6
        delete_wagon
      when 7
        move_train
      when 8
        show_trains_on_station
      when 9
        break
      when 10
        show_stations
        show_trains
        show_routes
      else
        puts "Такого пункта нет!"
      end
    end
  end

  def create_station
    puts "Введите название станции: "
    name = gets.chomp
    @stations << Station.new(name)
  end

  def create_train
    puts "Введите номер поезда:"
    number = gets.chomp

    puts "Укажите тип поезда:"
    puts "Грузовой - 1\nПассажирский - 2"
    type = gets.chomp.to_i
    train = type == 1? CargoTrain.new(number) : PassengerTrain.new(number)
    @trains << train
    puts "Поезд #{train.number} типа '#{train.type}' создан!"
  end

  def route_acts
    loop do
      puts "Выберите действие:"
      puts "Создать новый маршрут - 1\nДобавить станцию в маршрут - 2\nУдалить станцию из маршрута - 3\nВыход - 0"
      choice = gets.chomp.to_i
      case choice
      when 1
        create_route
      when 2
        add_station
      when 3
        delete_station
      when 0
        break
      else
        puts "Такого пункта нет!"
      end
    end
  end

  def create_route
    puts "Введите начальную станцию:"
    first_station = gets.chomp
    @stations << Station.new(first_station)
    puts "Введите конечную станцию:"
    last_station = gets.chomp
    @stations << Station.new(last_station)
    @routes << Route.new(first_station, last_station)
    @current_station_index = 0
  end

  def add_station
    puts "Выберите номер маршрута, в который вы хотите добавить станцию"
    show_routes
    route = @routes[gets.chomp.to_i-1]
    puts "Выберите номер станции"
    show_stations
    station = @stations[gets.chomp.to_i-1]
    route.add_station(station)
    puts "Станция #{station.name} добавлена в маршрут #{route.first_station} - #{route.last_station}"
  end

  def delete_station
    puts "Выберите номер маршрута, из которого вы хотите удалить станцию"
    show_routes
    route = @routes[gets.chomp.to_i-1]
    puts "Выберите номер станции"
    show_stations
    station = @stations[gets.chomp.to_i-1]
    route.delete_station(station)
    puts "Станция #{station.name} удалена из маршрута #{route.first_station} - #{route.last_station}"
  end

  def assign_route
    puts "Выберите порядковый номер поезда, которому хотите назначить маршрут"
    show_trains
    train = @trains[gets.chomp.to_i-1]
    puts "Выберите номер маршрута"
    show_routes
    route = @routes[gets.chomp.to_i-1]
    train.add_route(route)
    puts "Поезду #{train.number} добавлен маршрут #{route.first_station} - #{route.last_station}"
  end

  def add_wagon
    puts "Выберите порядковый номер поезда, к которому хотите прицепить вагон"
    show_trains
    number = @trains[gets.chomp.to_i-1].number
    train = @trains.find { |train| train.number == number}
    train.type == :passenger ? train.hitch_wagon(PassengerWagons.new) : train.hitch_wagon(CargoWagons.new)
  end

  def delete_wagon
    puts "Выберите порядковый номер поезда, от которого хотите отцепить вагон"
    show_trains
    number = @trains[gets.chomp.to_i-1].number
    train = @trains.find { |train| train.number == number }
    train.type == :passenger ? train.unhitch_wagon(PassengerWagons.new) : train.unhitch_wagon(CargoWagons.new)
  end

  def move_train
    puts "Выберите порядковый номер поезда, который хотите переместить"
    show_trains
    train = @trains[gets.chomp.to_i-1]
    puts "Следующая станция - 1\nПредыдущая станция - 2"
    choice = gets.chomp.to_i
    case choice
    when 1
      train.go_next_station
      puts "Поезд #{train.number} переместился на станцию #{train.current_station}"
    when 2
      train.go_previous_station
      puts "Поезд #{train.number} переместился на станцию #{train.current_station}"
    else
      puts "Такого пункта нет!"
    end

  end

  def show_trains_on_station
    show_stations
    puts "Выберите номер станции, на которой хотите посмотреть поезда"
    station = @stations[gets.chomp.to_i-1]
    station.trains.each_with_index { |train, index| puts "#{index+1}. #{train.number}"}
  end

  private
  def show_stations
    puts "Список станций:"
    @stations.each_with_index { |station, index| puts "#{index+1}. #{station.name}" }
  end

  def show_trains
    puts "Список поездов:"
    @trains.each_with_index { |train, index| puts "#{index+1}. #{train.number}"}
  end

  def show_routes
    puts "Список путей:"
    @routes.each_with_index { |route, index| puts "#{index+1}. #{route.first_station} - #{route.last_station}"}
  end

end

Menu.new.open_menu