require_relative './company'
require_relative './instance_counter'

class CargoCar
  include Company
  include InstanceCounter

  attr_reader :type, :id, :volume_filled

  def initialize(id, volume_filled)
    @volume_value = volume_value
    @volume_filled = 0
    @id = id
    @type = "cargo"
  end

  def fill_volume(volume)
    @volume_filled += volume if volume_left >= volume
  end

  def volume_left
    @volume_value - volume_filled
  end
end