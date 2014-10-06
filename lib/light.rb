require_relative 'cave_object'

class Light < CaveObject

  attr_accessor :diffuse, :specular, :const_atten, :lin_atten, :quad_atten, :type, :angle

  def initialize(name,
    visible: true,
    color: "255, 255, 255",
    lighting: false,
    clickthrough: false,
    aroundselfaxis: false,
    scale: 1,
    position: "(0, 0, 0)",
    relative_to: "Center",
    type: :point,
    diffuse: true,
    specular: true,
    const_atten: 1,
    lin_atten: 1,
    quad_atten: 0)

    super(name, visible: visible, color: color, lighting: false, clickthrough: clickthrough, aroundselfaxis: aroundselfaxis, scale: scale, position: position, relative_to: relative_to)
    @type, @diffuse, @specular, @const_atten, @lin_atten, @quad_atten = type, diffuse, specular, const_atten, lin_atten, quad_atten
    @angle = 180
  end

  def spotlight(angle)
    @type = :spot
    @angle = angle
  end

  def is_light?
    true
  end

end
