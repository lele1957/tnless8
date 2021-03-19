require_relative './company'
require_relative './instance_counter'


class PassengerCar

  include Company
  include InstanceCounter
  
  attr_reader :type, :id, :seats_amount, :seats_taken

  def initialize(id, seats_amount)
    @id = id
    @seats_amount = seats_amount
    @seats_taken = 0
    @type = "passenger"
    register_instance
  end
  def take_seat
    @seats_taken += 1 if seats_taken < seats_amount
  end

  def free_seats
    @seats_amount - seats_taken
  end
end