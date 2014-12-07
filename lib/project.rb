require_relative 'text'
require_relative 'group'
require_relative 'wall'
require_relative 'timeline'
require_relative 'box_of_text'
require_relative 'plane'
require_relative 'light'
require_relative 'particle_system'
require_relative 'image'

class Project

  attr_accessor :name, :global, :timelines, :particle_action_lists, :light, :hell_system
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
    @particle_action_lists = []

    @i = 1

    add_default_walls
    set_cave_start_position(y: 1)
    set_preview_start_position(y: 1)
  end

  def add_light
    @light = Light.new("light")
    @light.set_position(y: 3, z: 3)
  end

  def add_object(object)
    if has_object(object)
      split_name = object.name.split("_")
      if split_name[-1].include?("cp")
        split_name[-1] = "cp#{@i}"
      else
        split_name << "cp#{@i}"
      end

      @i += 1

      object.name = split_name.join("_")
      add_object(object)
    else
      @objects << object
      object.project = self
    end
  end

  def has_object(object)
    @objects.map(&:name).include?(object.name)
  end

  def has_group(group)
    @groups.map(&:name).include?(group.name)
  end

  def add_group(group)
    if has_group(group)
      split_name = group.name.split("_")

      if split_name[-1].include?("cp")
        split_name[-1] = "cp#{@i}"
      else
        split_name << "cp#{@i}"
      end

      @i += 1

      group.name = split_name.join("_")
      add_group(group)
    else
      @groups << group
      group.project = self
    end
  end

  def has_timeline(timeline)
    @timelines.map(&:name).include?(timeline.name)
  end

  def add_timeline(timeline)
    if has_timeline(timeline)
      split_name = timeline.name.split("_")
      if split_name[-1].include?("cp")
        split_name[-1] = "cp#{@i}"
      else
        split_name << "cp#{@i}"
      end

      timeline.name = split_name.join("_")
      @i += 1
      add_timeline(timeline)
    else
      @timelines << timeline
    end
  end

  def has_particle_action_list(action_list)
    @particle_action_lists.map(&:name).include?(action_list.name)
  end

  def add_particle_action_list(action_list)
    if has_particle_action_list(action_list)
      split_name = action_list.name.split("_")
      if split_name[-1].include?("cp")
        split_name[-1] = "cp#{@i}"
      else
        split_name << "cp#{@i}"
      end

      action_list.name = split_name.join("_")
      @i += 1
      add_particle_action_list(action_list)
    else
      @particle_action_lists << action_list
    end
  end

  def set_cave_start_position(x: 0, y: 2, z: 6)
    string = "(#{x}, #{y}, #{z})"
    @global[:cave_start_position] = string
  end

  def set_preview_start_position(x:0, y: 2, z: 6)
    string = "(#{x}, #{y}, #{z})"
    @global[:preview_start_position] = string
  end

  def add_default_walls
    front = Wall.new("FrontWall", "(0.0, 0.0, -4.0)", "(0.0, 1.0, 0.0)")
    left = Wall.new("LeftWall", "(-4.0, 0.0, 0.0)", "(0.0, 1.0, 0.0)")
    right = Wall.new("RightWall", "(4.0, 0.0, 0.0)", "(0.0, 1.0, 0.0)")
    floor = Wall.new("FloorWall", "(0.0, -4.0, 0.0)", "(0.0, 0.0, -1.0)")
    @walls = [front, left, right, floor]
  end

end
