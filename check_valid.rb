module CheckValid
  def valid?
    validate!
    true
  rescue
    false
  end
end