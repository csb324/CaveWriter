module Actionable

  def hide(duration: 0, delay: 0)
    action = Action.new(object: (is_object ? self : nil), group: (is_group ? self : nil), duration: duration)
    action.fade_out
    action.delay = delay
    action
  end

  def show(duration: 0, delay: 0)
    action = Action.new(object: (is_object ? self : nil), group: (is_group ? self : nil), duration: duration)
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

  def move_to(x: 0, y: 0, z: 0, duration: 1, delay: 0)
    timeline = Timeline.new("#{@name}_move_to_#{x}#{y}#{z}")
    moving = Action.new(object: (is_object ? self : nil), group: (is_group ? self : nil), duration: duration)
    moving.move_absolute(x: x, y: y, z: z)

    timeline.actions << moving
  end

  def move_distance(x: 0, y: 0, z: 0, duration: 1, delay: 0)
    moving = Action.new(object: (is_object ? self : nil), group: (is_group ? self : nil), duration: duration)
    moving.delay = delay
    moving.move_relative(x: x, y: y, z: z)

    moving
  end

end
