require_relative './station'
require_relative './route'
require_relative './passenger_train'
require_relative './cargo_train'
require_relative './cargo_car'
require_relative './passenger_car'

class Menu

def initialize
  @trains_list = []
  @stations_list = []
  @routes_list = []
  @cars_list = []
end

def start_program
  loop do
    options
    command = gets.chomp
    read(command)
  end
end

#все методы снизу private, потому что не должны вызываться извне, они используются для взаимодействия с пользователям через командно-текстовый интерфейс
private

def options
  puts "Введите, что вы хотите сделать:
  доступные команды: 
  0 - создать поезд;
  1 - создать станцию; 
  2 - создать маршрут; 
  3 - добавить станцию в маршрут; 
  4 - удалить станцию из маршрута;
  5 - назначить поезду маршрут; 
  6 - добавить вагон поезду;
  7 - отцепить вагон;
  8 - перемещать поезд по маршруту;
  9 - просмотреть список станций и список поездов на станциях;
  10 - создать вагон
  опции - просмотреть все опции снова
  finish - выйти из программы"
end


def create_train
  puts "Создать поезд:"
  puts "Введите название для объекта поезда"
  train_title = gets.chomp
  puts "Введите номер поезда"
  train_number = gets.chomp
  puts "Выберите тип - cargo или passenger"
  train_type = gets.chomp

  train_title = CargoTrain.new(train_number) if train_type == "cargo"
  train_title = PassengerTrain.new(train_number) if train_type == "passenger"
  
  puts "поезд #{train_title} был создан" if train_title.valid?
    @trains_list << train_title
end

def create_station
  puts "Создать станцию:"
  puts "Введите название для объекта станции"
  station_title = gets.chomp
  puts "Введите имя станции"
  station_name = gets.chomp

  station_title = Station.new(station_name)

  @stations_list << station_title
  puts "станция #{station_title} была создана"
end

def create_route
  puts "Создать маршрут:"
  puts "Введите название для объекта маршрута"
  route_title = gets.chomp
  puts "Введите номер первой станции из списка"
  @stations_list.each_with_index {|station, number| puts "#{number + 1 } - #{station.name}" }
  route_first = gets.chomp.to_i
  puts "Введите номер конечной станции"
  route_last = gets.chomp.to_i

  route_title = Route.new(@stations_list[route_first - 1], @stations_list[route_last - 1])
  @routes_list << route_title
  puts "Маршрут #{route_title} со станциями #{route_title.stations} был создан"
end 

def routes
  puts "Выберите маршрут из списка"
  @routes_list.each_with_index {|route, number| puts "#{number + 1 } - #{route.stations}" }
end

def trains
  puts "Выберите поезд из списка:"
  @trains_list.each_with_index {|train, number| puts "#{number + 1} - #{train}"}
end 

def add_station_to_route
  puts "Добавить станцию в маршрут:"
  puts "Введите номер станции из списка"
  @stations_list.each_with_index {|station, number| puts "#{number + 1 } - #{station.name}" }
  station_to_route = gets.chomp.to_i
  routes
  route = gets.chomp.to_i
  @routes_list[route - 1].add_station(@stations_list[station_to_route - 1])
  puts "Станция #{@stations_list[station_to_route - 1]} добавлена в маршрут #{@routes_list[route - 1]}"
end 

def delete_station_from_route
  puts "Удалить станцию из маршрута:"
  routes
  delete_from_route = gets.chomp.to_i
  puts "Введите номер станции из списка"
  @routes_list[delete_from_route -1].stations.each_with_index {|station, number| puts "#{number + 1 } - #{station.name}" }
  station_from_route = gets.chomp.to_i
  @routes_list[delete_from_route -1].delete_station(@routes_list[delete_from_route -1].stations[station_from_route - 1])
  puts "Станция удалена из маршрута #{@routes_list[delete_from_route -1]}"
end 

def set_train_to_route
  puts "Назначить маршрут поезду:"
  trains
  train_to_route = gets.chomp.to_i
  routes
  route_to_set = gets.chomp.to_i

  @trains_list[train_to_route - 1].set_route = @routes_list[route_to_set - 1]
  puts "Поезд #{@trains_list[train_to_route - 1]} следует маршруту #{@routes_list[route_to_set - 1]}"
end 

def create_railcar
  puts "Добавить вагон:"
  puts "Введите название:"
  rail_car = gets.chomp
  puts "Введите id"
  car_id = gets.chomp
  puts "Введите тип cargo или passenger"
  car_type = gets.chomp

  rail_car  = CargoCar.new(car_id) if car_type == "cargo"
  rail_car  = PassengerCar.new(car_id) if car_type == "passenger"
  @cars_list << rail_car 
  puts "Вагон #{rail_car} был создан"
end  

def add_car_to_train
  puts "Добавить вагон:"
  puts "Выберите вагон из списка:"
  @cars_list.each_with_index {|car, number| puts "#{number + 1} - #{car} #{car.id}"}
  car_to_add = gets.chomp.to_i
  trains
  train_from_list = gets.chomp.to_i

  @trains_list[train_from_list -1].add_car(@cars_list[car_to_add -1])
  puts "Вагон #{@cars_list[car_to_add -1]} добавлен к поезду #{@trains_list[train_from_list -1]}"
  @cars_list.delete_at(car_to_add - 1)
end 

def unhook_car
  puts "Отцепить вагон:"
  trains
  train_from_list = gets.chomp.to_i
  puts "Выберите вагон из списка:"
  @trains_list[train_from_list - 1].railcars.each_with_index {|car, number| puts "#{number + 1} - #{car} #{car.id}"}
  car_to_delete = gets.chomp.to_i
  @cars_list << @trains_list[train_from_list - 1].railcars[car_to_delete - 1]
  @trains_list[train_from_list - 1].drop_car(@trains_list[train_from_list - 1].railcars[car_to_delete -1])

  puts "Вагон отцеплен от поезда #{@trains_list[train_from_list - 1]}"
end 

def move_train
  puts "Перемещение поезда по маршруту:"
  trains
  train_to_move = gets.chomp.to_i
  puts "Выберите куда вы хотите переместить поезд - вперед иди назад"
  direction = gets.chomp

  @trains_list[train_to_move -1].station_forward if direction == "вперед" || direction == "forward"
  @trains_list[train_to_move -1].station_backward if direction == "назад" || direction == "backward"
  puts "#{@trains_list[train_to_move -1]} перемещен #{direction} по маршруту"
end 

def view_station_list
  puts "Просмотреть список станций и список поездов на станции:"
  @stations_list.each_with_index {|station, number| puts "#{number + 1} - #{station.name}, поезда: #{station.trains}"}
end 

def take_seat
    cars
    car_to_seat = gets.chomp.to_i
    if @cars_list[car_to_seat - 1].type == 'passenger'
      @cars_list[car_to_seat - 1].take_seat
    else
      puts 'This is a cargo wagon!'
    end
  end

  def take_volume
    cars
    car_to_fill = gets.chomp.to_i
    if @cars_list[car_to_fill - 1].type == 'cargo'
      puts 'Set volume amount'
      volume = gets.chomp.to_i
      @cars_list[car_to_fill - 1].fill_volume(volume)
    else
      puts 'That is a passenger wagon!'
    end
  end

  def view_railcar_list
    trains
    train_to_view = gets.chomp.to_i
    @trains_list[train_to_view - 1].yield_car do |car|
      if car.type == 'passenger'
        puts "id - #{car.id}, тип - #{car.type}"
         "занятых мест - #{car.seats_taken}"
         "свободных мест - #{car.free_seats}"
      end
      if car.type == 'cargo'
        puts "id - #{car.id}, тип - #{car.type}"
        "занятого объема - #{car.volume_filled}"
        "свободного объема - #{car.volume_left}"
      end
    end
  end

  def view_train_list
    stations
    station_to_view = gets.chomp.to_i
    @stations_list[station_to_view - 1].yield_train do |train|
      puts "Train №#{train.number}, type -  #{train.type}"
      "number of wagons - #{train.railcars.count}"
    end
  end


def read(command)
 case command
  when "0"
    begin
        create_train
      rescue RuntimeError => e
        puts e.message
        puts 'Введите данные заново'
        retry
      end
  when "1"
    create_station
  when "2"
    create_route
  when "3"
    add_station_to_route
  when "4"
    delete_station_from_route
  when "5"
    set_train_to_route
  when "6"
    add_car_to_train
  when "7"
    unhook_car
  when "8"
    move_train
  when "9"
    view_station_list
  when "10"
    create_railcar
    when '11'
      view_railcar_list
    when '12'
      view_train_list
    when '13'
      take_seat
    when '14'
      take_volume
  when "опции"
    options
  when "finish"
    abort "Программа завершена"
end
end

end