require_relative './company'
require_relative './instance_counter'
require_relative './check_valid'

class Train

  include Company
  include InstanceCounter
  include CheckValid  

   NUMBER_FORMAT = /^[a-zа-я0-9]{3}-*[a-zа-я0-9]{2}$/i
  
  @@trains = {}
  attr_reader :speed, :railcars, :number

  def self.find(num_to_find)
    @@trains[num_to_find]
  end

  def initialize(number)
    @number = number
    @railcars = []
    @speed = 0
    validate!
    @@trains[@number] = self
    register_instance
  end

  def yield_car
    @railcars.each { |railcar| yield(railcar) }
  end
  
  def stop
    @speed = 0
  end

  def speed_up(value)
    @speed += value
  end

  def add_car(car)
    @railcars << car if self.type == car.type
  end

  def drop_car(car)
    @railcars.delete(car)
  end

  def set_route=(route)
    @route = route
    @current_station_index = 0
    current_station.add_train(self)
  end

  def station_forward
    return unless next_station
      current_station.train_departure(self)
      @current_station_index += 1
      current_station.add_train(self)
  end

  def station_backward
    return unless previous_station
      current_station.train_departure(self)
      @current_station_index += 1
      current_station.add_train(self)
  end                

  protected
  # эти методы не ипользуются вне класса, но при этом должны работать с объектами класса(self)
  
  def validate!
    raise "number doesn't match format" if number !~ NUMBER_FORMAT
    raise "number cannot be nil" if number.nil?
  end

  def current_station
    @route.stations[@station]
  end

  def next_station
    @route.stations[@station + 1] if current_station != @route.stations.last
  end

  def previous_station
    @route.stations[@station - 1] if current_station != @route.stations.first
  end
end