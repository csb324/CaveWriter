class CaveObject
  attr_accessor :name, :visible,
    :color, :lighting, :clickthrough,
    :aroundselfaxis, :scale, :position,
    :project, :actions, :relative_to, :rotation

  def initialize(name,
    visible: true,
    color: "255, 255, 255",
    lighting: false,
    clickthrough: false,
    aroundselfaxis: false,
    scale: 1,
    position: "(0, 0, 0)",
    relative_to: "Center"
    )
    @name, @visible, @color, @lighting, @clickthrough, @aroundselfaxis, @scale, @position, @relative_to = name, visible, color, lighting, clickthrough, aroundselfaxis, scale, position, relative_to
    @actions = []
  end

  def set_position(x: 0, y: 0, z: 0)
    string = "(#{x}, #{y}, #{z})"
    @position = string
  end

  def set_rotation(axis:, angle:)
    @rotation = {}
    if axis == "y"
      @rotation[:axis] = "(0, 1, 0)"
    elsif axis == "z"
      @rotation[:axis] = "(0, 0, 1)"
    elsif axis == "x"
      @rotation[:axis] = "(1, 0, 0)"
    else
      @rotation[:axis] = axis
    end
    @rotation[:angle] = angle
  end

  def hide(duration: 0, delay: 0)
    action = Action.new(object: self, duration: duration)
    action.fade_out
    action.delay = delay
    action
  end

  def show(duration: 0, delay: 0)
    action = Action.new(object: self, duration: duration)
    action.fade_in
    action.delay = delay
    action
  end

  def blink(start_immediately: true, interval: 1)
    timeline = Timeline.new("#{@name}_blinker")
    start_over = timeline.reset
    start_over.delay = 2 * interval

    timeline.actions << hide
    timeline.actions << show(delay: interval)
    timeline.actions << start_over

    timeline

  end

end