require_relative 'actionable'
require_relative 'link'

class CaveObject

  include Actionable

  attr_accessor :name, :visible,
    :color, :lighting, :clickthrough,
    :aroundselfaxis, :scale, :position,
    :project, :actions, :relative_to, :rotation,
    :link

  def initialize(name,
    visible: true,
    color: "255, 255, 255",
    lighting: false,
    clickthrough: true,
    aroundselfaxis: false,
    scale: 1,
    position: "(0, 0, 0)",
    relative_to: "Center")

    @name, @visible, @color, @lighting, @clickthrough, @aroundselfaxis, @scale, @position, @relative_to = name, visible, color, lighting, clickthrough, aroundselfaxis, scale, position, relative_to
    @actions = []
    @link = nil

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

  def is_particle_system?
    false
  end

  def is_image?
    false
  end

  def is_group
    false
  end

  def is_light?
    false
  end

  def link_start(timeline)
    @link = Link.new(color: @color)
    @link.start_timeline(timeline)
  end

  def add_link(link)
    @link = link
    @link.color = @color
  end

  def restart_on_click
    @link = Link.new(color: @color)
    @link.restart_cave_link
  end

end
