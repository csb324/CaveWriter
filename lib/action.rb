class Action

  attr_accessor :duration, :delay
  attr_reader :object, :group, :timeline, :type, :position, :visible, :color, :scale, :rotation

  def initialize(object: nil, group: nil, timeline: nil, duration: 1.0)
    @object, @group, @timeline, @duration = object, group, timeline, duration

    if !@object && !@group && !@timeline
      puts "PROBLEM"
      return
    end

    @object.actions << self if @object
    @delay = 0.0
  end

  def start_timer
    @type = "start_timer"
  end

  def set_rotation(axis:, angle:)
    if !@type
      @type = "move_rel"
      @position = "(0, 0, 0)"
    end
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

  def move_relative(x: 0, y: 0, z: 0, string: nil)
    @type = "move_rel"

    string = "(#{x}, #{y}, #{z})" unless string
    @position = string
  end

  def move_absolute(x: 0, y: 0, z: 0, string: nil)
    @type = "move_abs"

    string = "(#{x}, #{y}, #{z})" unless string
    @position = string
  end

  def fade_out
    @type = "fade"
    @visible = false
  end

  def fade_in
    @type = "fade"
    @visible = true
  end

  def color_change(color_string)
    @type = "color"
    @color = color_string
  end

  def size_change(new_size)
    @type = "scale"
    @scale = new_size
  end

  def change_link
    puts "aaahhhhhhhh"
  end

end
