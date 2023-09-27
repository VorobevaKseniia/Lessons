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
    @wagons = []
  end

  def open_menu
    loop do
      puts "
      Выберите раздел:
      1. Раздел 'СТАНЦИЯ'  /создание, просмотр поездов
      2. Раздел 'ПОЕЗД'    /создание, назначение маршрута, управление вагонами, передвижение по маршруту
      3. Раздел 'МАРШРУТ'  /создание, модифицирование
      4. Выход
      0. Отладка"
      choice = gets.chomp.to_i
      case choice
      when 1
        station_acts
      when 2
        train_acts
      when 3
        route_acts
      when 4
        break
      when 0
        show_stations
        show_trains
        show_routes
        all_wagons
      else
        puts 'Такого пункта нет!'
      end
    end
  end

  # STATION
  def station_acts
    loop do
      puts "
      Выберите пункт:
      1. Создание станции
      2. Просмотр поездов на станции
      0. Вернуться на главное меню"

      choice = gets.chomp.to_i
      case choice
      when 1
        create_station
      when 2
        trains_on_station
      when 0
        break
      else
        puts 'Такого пункта нет!'
      end
    end
  end

  def create_station
    puts 'Введите название станции:'
    name = gets.chomp
    @stations << Station.new(name)
  rescue StandardError => e
    puts "#{e.message}"
    retry
  else
    puts "Станция #{name} создана!"
  end

  def show_trains_on_station
    show_stations
    puts 'Выберите номер станции, на которой хотите посмотреть поезда'
    station = @stations[gets.chomp.to_i - 1]
    station.trains.each_with_index { |train, index| puts "#{index + 1}. #{train.number}" }
  end

  def trains_on_station
    show_stations
    puts 'Выберите номер станции'
    station = @stations[gets.chomp.to_i - 1]
    station.each_train do |train|
      puts "Номер поезда: #{train.number}\nТип: #{train.type}\nКол-во вагонов: #{train.wagons.count}\n"
    end
  end

  # ROUTE
  def route_acts
    loop do
      puts "
      1. Создать новый маршрут
      2. Добавить станцию в маршрут
      3. Удалить станцию из маршрута
      0. Вернуться на главное меню"

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
        puts 'Такого пункта нет!'
      end
    end
  end

  def create_route
    begin
      puts 'Введите начальную станцию:'
      first_station = Station.new(gets.chomp)
    rescue StandardError => e
      puts "#{e.message}"
      retry
    else
      @stations << first_station
    end
    begin
      puts 'Введите конечную станцию:'
      last_station = Station.new(gets.chomp)
    rescue StandardError => e
      puts "#{e.message}"
      retry
    else
      @stations << last_station
      @routes << Route.new(first_station, last_station)
      @current_station_index = 0
    end
  end

  def add_station
    puts 'Выберите номер маршрута, в который вы хотите добавить станцию'
    show_routes
    route = @routes[gets.chomp.to_i - 1]
    puts 'Выберите номер станции'
    show_stations
    station = @stations[gets.chomp.to_i - 1]
    route.add_station(station)
    puts "Станция #{station.name} добавлена в маршрут #{route.stations[0].name} - #{route.stations[-1].name}"
  end

  def delete_station
    puts 'Выберите номер маршрута, из которого вы хотите удалить станцию'
    show_routes
    route = @routes[gets.chomp.to_i - 1]
    puts 'Выберите номер станции'
    show_stations
    station = @stations[gets.chomp.to_i - 1]
    route.delete_station(station)
    puts "Станция #{station.name} удалена из маршрута #{route.stations[0].name} - #{route.stations[-1].name}"
  end

  # TRAIN
  def train_acts
    loop do
      puts "
      Выберите действие:
      1. Создать поезд
      2. Назначить маршрут поезду
      3. Переместить поезд по маршруту
      4. Раздел 'ВАГОН'                 / добавить/ отцепить, зарезервировать место/ добавить объем
      5. Список вагонов поезда
      0. Вернуться на главное меню"

      choice = gets.chomp.to_i
      case choice
      when 1
        create_train
      when 2
        assign_route
      when 3
        move_train
      when 4
        wagon_acts
      when 5
        show_wagons
      when 0
        break
      else
        puts 'Такого пункта нет!'
      end
    end
  end

  def create_train
    puts 'Введите номер поезда:'
    number = gets.chomp
    puts "Укажите тип поезда:\n1. Грузовой\n2. Пассажирский"
    type = gets.chomp.to_i
    train = CargoTrain.new(number) if type == 1
    train = PassengerTrain.new(number) if type == 2
    @trains << train
    puts "Поезд #{train.number} типа '#{train.type}' создан!"
  rescue NoMethodError
    puts 'Тип поезда не указан или указан не верно!'
    retry
  rescue StandardError => e
    puts "#{e.message}"
    retry
  end

  def assign_route
    puts 'Выберите порядковый номер поезда, которому хотите назначить маршрут'
    show_trains
    train = @trains[gets.chomp.to_i - 1]
    puts 'Выберите номер маршрута'
    show_routes
    route = @routes[gets.chomp.to_i - 1]
    train.add_route(route)
    puts "Поезду #{train.number} добавлен маршрут #{route.stations[0].name} - #{route.stations[-1].name}"
  end

  def move_train
    puts 'Выберите порядковый номер поезда, который хотите переместить'
    show_trains
    train = @trains[gets.chomp.to_i - 1]
    puts "Следующая станция - 1\nПредыдущая станция - 2"
    choice = gets.chomp.to_i
    case choice
    when 1
      train.go_next_station
      puts "Поезд #{train.number} переместился на станцию #{train.current_station.name}"
    when 2
      train.go_previous_station
      puts "Поезд #{train.number} переместился на станцию #{train.current_station.name}"
    else
      puts 'Такого пункта нет!'
    end
  end

  # WAGON
  def wagon_acts
    loop do
      puts "
      Выберите действие:
      1. Добавить вагон
      2. Отцепить вагон
      3. Зарезервировать место / добавить объём
      0. Вернуться в предыдущий раздел"

      choice = gets.chomp.to_i
      case choice
      when 1
        add_wagon
      when 2
        delete_wagon
      when 3
        occupy_seat_volume
      when 0
        break
      else
        puts 'Такого пункта нет!'
      end
    end
  end

  def add_wagon
    puts 'Выберите порядковый номер поезда, к которому хотите прицепить вагон'
    show_trains
    number = @trains[gets.chomp.to_i - 1].number
    train = @trains.find { |train| train.number == number }
    if train.type == :passenger
      puts 'Введите общее количество мест в вагоне'
      seats = gets.chomp.to_i
      wagon = PassengerWagons.new seats
      @wagons << wagon
      train.hitch_wagon(wagon)
    elsif train.type == :cargo
      puts 'Введите общий объём вагона'
      volume = gets.chomp.to_i
      wagon = CargoWagons.new volume
      @wagons << wagon
      train.hitch_wagon(wagon)
    else
      puts 'Тип указан не верно!'
    end
    puts 'Вагон прицеплен!'
  end

  def delete_wagon
    puts 'Выберите порядковый номер поезда, от которого хотите отцепить вагон'
    show_trains
    number = @trains[gets.chomp.to_i - 1].number
    train = @trains.find { |train| train.number == number }
    puts 'Выберите порядковый номер вагона'
    show_wagons
    wagon = @wagons[gets.chomp.to_i - 1]
    train.unhitch_wagon(wagon) if train.type == wagon.type
    puts 'Вагон отцеплен!'
  end

  def show_wagons
    show_trains
    puts 'Выберите номер поезда'
    train = @trains[gets.chomp.to_i - 1]
    puts 'Список вагонов:'
    if train.type == :passenger
      train.each_wagon do |wagon, index|
        puts "#{index + 1}. #{wagon.type}\nКол-во свободных мест: #{wagon.free}\nКол-во занятых мест: #{wagon.occupied}"
      end
    else
      train.each_wagon do |wagon, index|
        puts "#{index + 1}. #{wagon.type}\nКол-во свободного объёма: #{wagon.free}\nКол-во занятого объёма: #{wagon.occupied}"
      end
    end
  end

  def occupy_seat_volume
    all_wagons
    puts 'Выберите порядковый номер вагона'
    wagon = @wagons[gets.chomp.to_i - 1]
    if wagon.type == :passenger
      wagon.occupy_seat if wagon.free != 0
      puts 'Место зарезервировано!'
    else
      puts 'Введите объём:'
      volume = gets.chomp.to_i
      wagon.occupy_volume(volume) if wagon.free >= volume
      puts 'Объём добавлен!'
    end
  end

  private

  def show_stations
    puts 'Список станций:'
    @stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
  end

  def show_trains
    puts 'Список поездов:'
    @trains.each_with_index { |train, index| puts "#{index + 1}. #{train.number}" }
  end

  def show_routes
    puts 'Список путей:'
    @routes.each_with_index do |route, index|
      puts "#{index + 1}. #{route.stations[0].name} - #{route.stations[-1].name}"
    end
  end

  def all_wagons
    puts 'Список вагонов:'
    @wagons.each_with_index do |wagon, index|
      puts "#{index + 1}. Тип: #{wagon.type}; Вместимость: #{wagon.seats_volume}"
    end
  end
end

Menu.new.open_menu
