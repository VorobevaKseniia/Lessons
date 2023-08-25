require_relative 'station'
require_relative 'route'
require_relative 'train'

class Menu

  def open_menu
    puts "Введите цифру от 1 до 8"
    puts "1. Создать станцию"
    puts "2. Создать поезд"
    puts "3. Создать маршрут и управлять станциями в нем (добавлять, удалять)"
    puts "4. Назначить маршрут поезду"
    puts "5. Добавить вагон к поезду"
    puts "6. Отцепить вагон от поезда"
    puts "7. Переместить поезд по маршруту вперед и назад"
    puts "8. Просмотреть список станций и список поездов на станции"

    choice = gets.chomp.to_i

    case choice
    when 1
      create_station
    when 2
      create_train
    when 3
      create_new_route
    when 4
      add_new_route
    when 5
      add_wagon
    when 6
      delete_wagon
    when 7
      move_next_previous_station
    when 8
      show_station_list_and_trains
    else
    puts "Error!"
    end
  end

  def create_station
    create_station = Route.new(first_station, last_station)
    print "Введите название станции: "
    name_station = gets.chomp
    create_station.add_station(name_station)
  end

  def create_train
    puts "Введите номер поезда: "
    train_number = gets.chomp
    puts "Введите тип поезда (1 - пассажирский, 2 - грузовой): "
    type = gets.chomp
    puts "Введите количество вагонов: "
    number_of_wagons = gets.chomp.to_i
    create_train = Train.new(train_number, type, number_of_wagons)
    trains << create_train
    puts "Поезд номер #{train_number} создан"
  end

  def create_new_route
    puts "Начальная станция: "
    first_station = gets.chomp
    puts "Конечная станция: "
    last_station = gets.chomp
    new_route = Route.new(first_station,last_station)
    puts "Добавить станцию - 1\n Удалить станцию - 2"
    add_or_delete = gets.chomp.to_i
    case add_or_delete
    when 1
      "Введите название станции"
      station = gets.chomp
      new_route.add_station(station)
    when 2
      "Введите название станции"
      station = gets.chomp
      new_route.delete_station(station)
    else
      print "Error!"
    end
  end

  def add_new_route
    puts "Введите номер поезда: "
    train_number = gets.chomp
    puts "Введите тип поезда (1 - пассажирский, 2 - грузовой): "
    type = gets.chomp
    case type
    when 1
      type = "пассажирский"
    when 2
      type = "грузовой"
    else
      print "Error!"
    end
    puts "Введите количество вагонов: "
    number_of_wagons = gets.chomp.to_i
    new_route = Train.new(train_number, type, number_of_wagons)
    puts "Введите номер маршрута: "
    route = gets.chomp
    new_route.assign_route(route)
  end

  def add_wagon
    puts "Введите название станции, на которой находится поезд: "
    station = gets.chomp
    puts "Введите номер поезда: "
    train_number = gets.chomp
    carriage = Station.new(station)
    carriage.hitch_wagon if train_number.include? trains
    print "Вагон прицеплен!"
  end

  def delete_wagon
    puts "Введите название станции, на которой находится поезд: "
    station = gets.chomp
    puts "Введите номер поезда: "
    train_number = gets.chomp
    carriage = Station.new(station)
    carriage.unhitch_wagon if train_number.include? trains
    print "Вагон отцеплен!"
  end

  def move_next_previous_station
    puts "Следующая станция - 1\n Предыдущая станция - 2"
    choice_1 = gets.chomp.to_i
    case choice_1
    when 1
      puts "Введите название станции, на которой находится поезд: "
      station = gets.chomp
      puts "Введите номер поезда: "
      train_number = gets.chomp
      go_next = Station.new(station)
      go_next.next_station if train_number.include? trains
    when 2
      puts "Введите название станции, на которой находится поезд: "
      station = gets.chomp
      puts "Введите номер поезда: "
      train_number = gets.chomp
      go_next = Station.new(station)
      go_next.previous_station if train_number.include? trains
    else
      print "Error!"
    end
  end

  def show_station_list_and_trains
    puts "Введите название станции: "
    name_station = gets.chomp
    current_station = Station.new(name_station)
    puts current_station.stations
    puts current_station.trains
  end

end


start = Menu.new
start.open_menu
