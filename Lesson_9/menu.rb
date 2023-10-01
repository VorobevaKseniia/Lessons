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
      station_acts if choice == 1
      train_acts if choice == 2
      route_acts if choice == 3
      break if choice == 4

      show_all if choice.zero?
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
      create_station if choice == 1
      trains_on_station if choice == 2
      break if choice.zero?
    end
  end

  def create_station
    puts 'Введите название станции:'
    name = gets.chomp
    @stations << Station.new(name)
  rescue StandardError => e
    puts e.message
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
      create_route if choice == 1
      add_station if choice == 2
      delete_station if choice == 3
      break if choice.zero?
    end
  end

  def create_route
    puts 'Введите начальную станцию:'
    first_station = Station.new(gets.chomp)
    puts 'Введите конечную станцию:'
    last_station = Station.new(gets.chomp)
  rescue StandardError => e
    puts "#{e.message}"
    retry
  else
    @stations << first_station
    @stations << last_station
    @routes << Route.new(first_station, last_station)
    @current_station_index = 0
  end

  def add_station
    puts 'Выберите номер маршрута, в который вы хотите добавить станцию'
    show_routes
    route = @routes[gets.chomp.to_i - 1]
    puts 'Выберите номер станции'
    show_stations
    station = @stations[gets.chomp.to_i - 1]
    route.add_station(station)
    puts "Станция #{station.name} добавлена в маршрут #{route.stations.first.name} - #{route.stations.last.name}"
  end

  def delete_station
    puts 'Выберите номер маршрута, из которого вы хотите удалить станцию'
    show_routes
    route = @routes[gets.chomp.to_i - 1]
    puts 'Выберите номер станции'
    show_stations
    station = @stations[gets.chomp.to_i - 1]
    route.delete_station(station)
    puts "Станция #{station.name} удалена из маршрута #{route.stations.first.name} - #{route.stations.last.name}"
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
      create_train if choice == 1
      assign_route if choice == 2
      move_train if choice == 3
      wagon_acts if choice == 4
      show_wagons if choice == 5
      break if choice.zero?
    end
  end

  def create_train
    puts 'Введите номер поезда:'
    number = gets.chomp
    puts "Укажите тип поезда:\n1. Грузовой\n2. Пассажирский"
    type = gets.chomp.to_i
    create_train_with_type(number, type)
  rescue NoMethodError
    puts 'Тип поезда не указан или указан не верно!'
    retry
  rescue StandardError => e
    puts e.message
    retry
  end

  def create_train_with_type(number, type)
    train = CargoTrain.new(number) if type == 1
    train = PassengerTrain.new(number) if type == 2
    @trains << train
    puts "Поезд #{train.number} типа '#{train.type}' создан!"
  end

  def assign_route
    puts 'Выберите порядковый номер поезда и маршрута:'
    show_trains
    train = @trains[gets.chomp.to_i - 1]
    show_routes
    route = @routes[gets.chomp.to_i - 1]
    train.add_route(route)
    puts "Поезду #{train.number} добавлен маршрут #{route.stations.first.name} - #{route.stations.last.name}"
  end

  def move_train
    puts 'Выберите порядковый номер поезда, который хотите переместить'
    show_trains
    train = @trains[gets.chomp.to_i - 1]
    puts "Следующая станция - 1\nПредыдущая станция - 2"
    choice = gets.chomp.to_i
    to_next_station(train) if choice == 1
    to_previous_station(train) if choice == 2
  end

  def to_next_station(train)
    train.go_next_station
    puts "Поезд #{train.number} переместился на станцию #{train.current_station.name}"
  end

  def to_previous_station(train)
    train.go_previous_station
    puts "Поезд #{train.number} переместился на станцию #{train.current_station.name}"
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
      do_wagon_acts(choice)
      break if choice.zero?
    end
  end

  def do_wagon_acts(choice)
    add_wagon if choice == 1
    delete_wagon if choice == 2
    occupy_seat_volume if choice == 3
  end

  def add_wagon
    puts 'Выберите порядковый номер поезда, к которому хотите прицепить вагон'
    show_trains
    train = train_from_user
    type_passenger(train) if train.type == :passenger
    type_cargo(train) if train.type == :cargo
  end

  def type_passenger(train)
    puts 'Введите общее количество мест в вагоне'
    seats = gets.chomp.to_i
    wagon = PassengerWagons.new seats
    @wagons << wagon
    train.hitch_wagon(wagon)
    puts 'Вагон прицеплен!'
  end

  def type_cargo(train)
    puts 'Введите общий объём вагона'
    volume = gets.chomp.to_i
    wagon = CargoWagons.new volume
    @wagons << wagon
    train.hitch_wagon(wagon)
    puts 'Вагон прицеплен!'
  end

  def delete_wagon
    puts 'Выберите порядковый номер поезда, от которого хотите отцепить вагон'
    show_trains
    train = train_from_user
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
    print_passenger(train) if train.type == :passenger
    print_cargo(train) if train.type == :cargo
  end

  def print_passenger(train)
    train.each_wagon do |wagon, index|
      puts "#{index + 1}. #{wagon.type}\nКол-во свободных мест: #{wagon.free}\nКол-во занятых мест: #{wagon.occupied}"
    end
  end

  def print_cargo(train)
    train.each_wagon do |wagon, index|
      puts "#{index + 1}. #{wagon.type}\nКол-во свободного объёма: #{wagon.free}\n"
      "Кол-во занятого объёма: #{wagon.occupied}"
    end
  end

  def occupy_seat_volume
    all_wagons
    puts 'Выберите порядковый номер вагона'
    wagon = @wagons[gets.chomp.to_i - 1]
    book_seat(wagon) if wagon.type == :passenger
    add_volume(wagon) if wagon.type == :cargo
  end

  def book_seat(wagon)
    wagon.occupy_seat if wagon.free != 0
    puts 'Место зарезервировано!'
  end

  def add_volume(wagon)
    puts 'Введите объём:'
    volume = gets.chomp.to_i
    wagon.occupy_volume(volume) if wagon.free >= volume
    puts 'Объём добавлен!'
  end

  private

  def train_from_user
    number = @trains[gets.chomp.to_i - 1].number
    @trains.find { |train| train.number == number }
  end

  def show_all
    show_stations
    show_trains
    show_routes
    all_wagons
  end

  def show_stations
    puts 'Список станций:'
    @stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
  end

  def show_trains
    puts 'Список поездов:'
    @trains.each_with_index { |train, index| puts "#{index + 1}. #{train.number}" } if @trains.any?
  end

  def show_routes
    puts 'Список путей:'
    @routes.each_with_index do |route, index|
      puts "#{index + 1}. #{route.stations.first.name} - #{route.stations.last.name}"
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
