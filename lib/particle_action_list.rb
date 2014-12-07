require_relative 'particle_action'

class ParticleActionList

  attr_accessor :name
  attr_reader :rate, :remove_condition, :age, :actions, :source_type, :source_point,
    :velocity_type, :velocity_line, :velocity_cylinder_p2, :velocity_radius,
    :source_cylinder_p2, :source_cylinder_radius, :source_cylinder_inner_radius

  def initialize(name, rate: 1, remove_condition: :age, source_type: :point)
    @name, @rate, @source_type, @remove_condition = name, rate, source_type, remove_condition
    @age = 1000
    @velocity_type = :line
    set_velocity
    set_position
    @actions = []
    $project.add_particle_action_list(self)
  end

  def set_position(x: 0, y: 0, z: 0)
    # point from which particles originate
    # RELATIVE TO PARTICLE SYSTEM OBJECT
    # leave it at 0, 0, 0 most of the time
    string = "(#{x}, #{y}, #{z})"
    @source_point = string
  end

  def set_cylinder_velocity(height: 0.5, radius: 0.5)
    @velocity_type = :cylinder
    @velocity_cylinder_p2 = "(0, #{height}, 0)"
    @velocity_radius = radius
  end

  def set_cylinder_source(height: 0.5, outer_radius: 5.0, inner_radius: 4.0)
    @source_type = :cylinder
    @source_cylinder_p2 = "(0, #{height}, 0)"
    @source_cylinder_radius = outer_radius
    @source_cylinder_inner_radius = inner_radius

  end


  def set_velocity(x: 0, y: 0, z: 0)
    # direction and initial velocity of particles
    @velocity_type = :line
    string = "(#{x}, #{y}, #{z})"
    @velocity_line = string
  end

  def set_max_age(ms)
    @age = ms
  end

  def add_action(particle_action)
    @actions << particle_action
  end

  def add_fall
    fall = ParticleAction.new(self)
    fall.fall_down(0.6)
  end

  def add_bounce_on_floor
    bounce = ParticleAction.new(self)
    bounce.bounce_on_floor
  end

end
