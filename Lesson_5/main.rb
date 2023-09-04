require_relative 'modules'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_wagons'
require_relative 'cargo_wagons'
require_relative 'wagons'

class Menu
  attr_accessor :stations, :trains, :routes
  def initialize
    @@stations ||= []
    @@trains = []
    @routes ||= []
    @wagons = []
  end

  def open_menu
    loop do
      puts "Введите цифру от 1 до 8"
      puts "1. Создать станцию"
      puts "2. Создать поезд"
      puts "3. Создать маршрут и управлять станциями в нем (добавлять, удалять)"
      puts "4. Назначить маршрут поезду"
      puts "5. Добавить вагон к поезду"
      puts "6. Отцепить вагон от поезда"
      puts "7. Переместить поезд по маршруту вперед и назад"
      puts "8. Просмотреть список станций и список поездов на станции"
      puts "9. Выход"
      puts "10. Отладка"

      choice = gets.chomp.to_i

      case choice
      when 1
        create_station
      when 2
        create_train
      when 3
        create_new_route
      when 4
        assign_route
      when 5
        add_wagon
      when 6
        delete_wagon
      when 7
        move_next_previous_station
      when 8
        show_station_list_and_trains
      when 9
        break
      when 10
        show
      else
      puts "Error!"
      end
    end
  end

  def create_station
    print "Введите название станции: "
    name_station = gets.chomp
    new_station = Station.new(name_station)
    @@stations << new_station
    puts "Станция #{new_station.to_s} создана!"
  end

  def create_train
    puts "Введите номер поезда: "
    number = gets.chomp
    puts "Введите тип поезда (1 - пассажирский, 2 - грузовой): "
    type = gets.chomp.to_i
    case type
    when 1
      passenger_train = PassengerTrain.new(number)
      @@trains << passenger_train
      puts "Пассажирский поезд номер #{number} создан"
    when 2
      cargo_train = CargoTrain.new(number)
      @@trains << cargo_train
      puts "Грузовой поезд номер #{number} создан"
    else
      print "Error!"
    end
  end

  def create_new_route
    puts "Начальная станция: "
    first_station = Station.new(gets.chomp)
    puts "Конечная станция: "
    last_station = Station.new(gets.chomp)
    new_route = Route.new(first_station,last_station)
    loop do
    puts "Добавить станцию - 1\n Удалить станцию - 2\n Выход - 0"
    add_or_delete = gets.chomp.to_i
    case add_or_delete
    when 1
      puts "Введите название станции"
      station = gets.chomp
      new_route.add_station Station.new(station)
    when 2
      puts "Введите название станции"
      station = gets.chomp
      new_route.delete_station Station.new(station)
    else
      print "Error!"
    end
    break if add_or_delete == 0
    end
    @routes << new_route
  end

  def assign_route
    all_routes
    all_trains
    train = get_train
    print "Введите номер маршрута: "
    route_number = gets.chomp.to_i
    train.assign_route(route_number)
  end

  def get_train  # поиск и вывод поезда
    print "Введите номер поезда: "
    number = gets.chomp
    @@trains.find { |train| train.number == number }
  end

  def all_routes
    puts "Список маршрутов"
    @routes.each_with_index do |route, index|
      puts "#{index+1}. #{route.first_station} - #{route.last_station}"
    end
  end

  def all_trains
    puts "Список поездов"
    @@trains.each { |train| puts train.number}
  end

  def all_stations
    puts "Список станций"
    @@stations.each { |station| puts station.station_name}
  end

  def add_wagon
    all_trains
    puts "Введите номер поезда: "
    number = gets.chomp
    train = @@trains.find { |train| train.number == number }

    if train.is_a? CargoTrain # принадлежит ли объект к классу или его подклассу? (kind_of, instance_of)
      train.hitch_wagon CargoWagons.new
    elsif train.is_a? PassengerTrain
      train.hitch_wagon PassengerWagons.new
    else "Error!"
    end
    print "Вагон прицеплен!"
  end

  def delete_wagon
    all_trains
    puts "Введите номер поезда: "
    number = gets.chomp
    train = @@trains.find { |train| train.number == number }

    if train.is_a? CargoTrain
      train.unhitch_wagon CargoWagons.new
    elsif train.is_a? PassengerTrain
      train.unhitch_wagon PassengerWagons.new
    else "Error!"
    end
    print "Вагон отцеплен!"
  end

  def move_next_previous_station
    puts "Следующая станция - 1\n Предыдущая станция - 2"
    next_previous = gets.chomp.to_i
    case next_previous
    when 1
      puts "Введите название станции, на которой находится поезд: "
      station = gets.chomp
      puts "Введите номер поезда: "
      number = gets.chomp
      go_next = Station.new(station)
      go_next.go_next_station if number.include? trains && next_station
    when 2
      puts "Введите название станции, на которой находится поезд: "
      station = gets.chomp
      puts "Введите номер поезда: "
      number = gets.chomp
      go_previous = Station.new(station)
      go_previous.go_previous_station if number.include? trains && previous_station
    else
      print "Error!"
    end
  end

  def show_station_list_and_trains
    all_stations
    puts "Введите название станции: "
    name_station = gets.chomp
    current_station = Station.new(name_station)
    puts current_station.stations
    puts current_station.trains
  end

  def show
    p @@stations
    p @@trains
    p @routes
    p @wagons
  end

end


start = Menu.new
start.open_menu
