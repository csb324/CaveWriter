class Enemy

  attr_accessor :name, :failure_message, :body

  def initialize(name:, failure:, z_position:)
    @name, @z_position = name, z_position
    real_depth = z_position * -2

    @body = Text.new("enemy", color: "90, 90, 90", scale: 3)
    @body.set_position(x: 0, y: -3, z: real_depth)
    @body.set_content(name, font: "PressStart2P.ttf")
    @body.feet_deep = 1

    @failure_message = Text.new("fail", scale: 2, visible: false)
    @failure_message.set_position(x: 0, y: 0, z: real_depth - 8)
    @failure_message.set_content(failure, font: "PressStart2P.ttf")

  end

end
