class ParticleAction

  attr_reader :type, :resilience, :friction, :cutoff, :plane_point, :plane_normal, :gravity_direction

  def initialize(particle_action_list)
    particle_action_list.add_action(self)
  end

  def bounce_on_floor(resilience: 0.6, friction: 1)
    @type = :bounce
    @resilience = resilience
    @friction = friction
    @cutoff = 1.0
    @plane_point = "(0, -12, 0)"
    @plane_normal = "(0, 1.0, 0)"
  end

  def fall_down(speed)
    @type = :gravity
    @gravity_direction = "(0, #{-0.1 * speed}, 0)"
  end

end
