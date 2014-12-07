class MysteryBox

  attr_accessor :box, :particles

  def initialize(front_z, block_height, action_list)

    real_height = (block_height * 2) - 4
    real_depth = (front_z * -2)

    text_content_options = [
      "ballet classes",
      "learn to read before any of your friends",
      "piano lessons",
      "'gifted and talented'",
      "hold a charity lemonade stand",
      "memorize your multiplication tables",
      "math club",
      "after school pottery class",
      "youth basketball MVP",
      "honors math",
      "guitar lessons",
      "cotillion",
      "perform in the school talent show",
      "take latin"
    ]

    @box = Text.new("mystery", color: "255, 152, 78", scale: 10)
    @box.set_position(x: 0, y: real_height, z: real_depth)
    @box.set_content("?")
    @box.feet_deep = 2

    @particles = ParticleSystem.new_text_particle("box",
      content: text_content_options.sample,
      font: "PressStart2P.ttf",
      max_particles: 1,
      z: real_depth,
      y: real_height)

    @particles.connect_actions(action_list)
    @particles.visible = false

  end

end
