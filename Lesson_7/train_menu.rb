# frozen_string_literal: true
require_relative 'menu'
require_relative 'station'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagons'
require_relative 'passenger_wagons'
require_relative 'cargo_wagons'
require_relative 'route'
require_relative 'modules'
class Train_menu

  def open_menu
    loop do
      puts "
      Выберите пунк от 1 до 10
      02. Создать поезд
      04. Назначить маршрут поезду
      05. Добавить вагон к поезду
      06. Отцепить вагон от поезда
      07. Переместить поезд по маршруту вперед и назад
      08. Просмотреть список станций и список поездов на станции
      09. Выход
      10. Отладка
      "

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
end