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

    $project.add_object(self)
  end

  def is_object
    true
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

  def wobble(start_immediately: true, angle: 50.0, interval: 2, timeline: nil)

    timeline = Timeline.new("#{@name}_wobble") unless timeline

    rotate = Action.new(object: self, duration: interval)
    random_axis = "(#{(-2..3).to_a.sample}, #{(-2..3).to_a.sample}, #{(-2..3).to_a.sample})"
    rotate.set_rotation(axis: random_axis, angle: angle)
    rotate.move_absolute(string: position)

    restore = Action.new(object: self, duration: interval)
    random_axis = "(#{(-2..3).to_a.sample}, #{(-2..3).to_a.sample}, #{(-2..3).to_a.sample})"
    restore.set_rotation(axis: random_axis, angle: angle)
    restore.move_absolute(string: position)

    restore.delay = interval

    start_over = timeline.reset
    start_over.delay = (interval * 2) - 0.5

    timeline.actions << rotate
    timeline.actions << restore
    timeline.actions << start_over

    timeline
  end

  def is_text?
    false
  end

  def is_light?
    false
  end

end
