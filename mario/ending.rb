class Ending

  def initialize(z_position)

    actual_z = z_position * -2
    flagpole(z_position - 2)

    castle = Image.new("castle", scale: 10, file_path: "./castle copy.png")
    castle.set_position(z: actual_z)

    darkroom = Text.new("darkroom", color: "5, 5, 5", scale: 1000)
    darkroom.set_content(".", font: "game_over.ttf", depth: 6)
    darkroom.set_position(z: actual_z - 0.1, y: 50, x: -4)

  end

  def flagpole(center_z)
    height_in_feet = 15

    pole = Text.new("pole", color: "98, 98, 110", scale: 1.5)
    pole.set_content("o")
    pole.feet_deep = height_in_feet
    pole.set_rotation(axis: "x", angle: 90)
    pole.set_position(x: 0, y: -4, z: center_z * -2)

  end

end
