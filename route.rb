require_relative './instance_counter'
require_relative './check_valid'

class Route
  include InstanceCounter
  include CheckValid
  
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station,last_station]
    register_instance
    validate!
    valid?
  end
  
  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station)
  end

  protected 

  def validate!
    raise "Route cannot be nil" if stations.nil?
    raise 'Wrong class of the attribute' unless stations.is_a? class_name
  end
end