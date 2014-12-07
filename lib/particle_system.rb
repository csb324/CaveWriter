require_relative 'cave_object'
require_relative 'text'
require_relative 'particle_action_list'
require_relative 'particle_action'

class ParticleSystem < CaveObject

  attr_accessor :max_particles, :particle_action_list, :particle_group, :speed, :visible

  def initialize(name,
    visible: true,
    position: "(0, 0, 0)",
    relative_to: "Center",
    max_particles: 100,
    speed: 1.0)

    super(name, visible: visible, position: position, relative_to: relative_to)
    @max_particles, @speed = max_particles, speed
  end



  def self.new_text_particle(name,
    content:,
    font: "Courier.ttf",
    color: "255, 255, 255",
    scale: 1,
    max_particles: 1,
    speed: 1.0,
    x: 0, y: 0, z: 0)

    system = self.new(name, max_particles: max_particles, speed: speed)

    word = Text.new("bouncing_text", color: color, scale: scale, visible: false)
    word.set_content(content, font: font)

    group = Group.new("bounce_group")
    group.add_member(word)

    system.set_position(x: x, y: y, z: z)
    system.connect_group(group)

    system

  end

  def connect_group(group)
    @particle_group = group.name
  end

  def connect_actions(list)
    @particle_action_list = list.name
  end

  def is_particle_system?
    true
  end

end
