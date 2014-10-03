class Wall

  attr_reader :name, :position, :look_up

  def initialize(name, position, look_up)
    @name, @position, @look_up = name, position, look_up
    @relative_to = "Center"
  end

end
