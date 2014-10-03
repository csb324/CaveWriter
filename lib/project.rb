require_relative 'text'
require_relative 'group'
require_relative 'wall'
require_relative 'timeline'
require_relative 'box_of_text'

class Project

  attr_accessor :name, :global, :timelines
  attr_reader :objects, :groups, :walls

  def initialize(name)
    @name = name
    @objects = []
    @groups = []
    @timelines = []
    @global = {
      cave_start_position: "(0.0, 0.0, 0.0)",
      preview_start_position: "(0.0, 0.0, 0.0)",
      color: "0, 0, 0",
      wand_navigation: {allow_rotation: false, allow_movement: false}
    }

    add_default_walls
  end

  def add_object(object)
    if has_object(object.name)
      object.name = object.name + "_cp"
      add_object(object)
    else
      @objects << object
      object.project = self
    end
  end

  def has_object(object_name)
    @objects.map(&:name).include?(object_name)
  end

  def add_group(group)
    @groups << group
    group.project = self
  end

  def set_cave_start_position(x: 0, y: 2, z: 6)
    string = "(#{x}, #{y}, #{z})"
    @global.cave_start_position = string
  end

  def set_preview_start_position(x:0, y: 2, z: 6)
    string = "(#{x}, #{y}, #{z})"
    @global.preview_start_position = string
  end

  def add_default_walls
    front = Wall.new("FrontWall", "(0.0, 0.0, -4.0)", "(0.0, 1.0, 0.0)")
    left = Wall.new("LeftWall", "(-4.0, 0.0, 0.0)", "(0.0, 1.0, 0.0)")
    right = Wall.new("RightWall", "(4.0, 0.0, 0.0)", "(0.0, 1.0, 0.0)")
    floor = Wall.new("FloorWall", "(0.0, -4.0, 0.0)", "(0.0, 0.0, -1.0)")
    @walls = [front, left, right, floor]
  end

end
