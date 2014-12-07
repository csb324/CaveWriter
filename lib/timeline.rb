require_relative 'action'
require 'pry'

class Timeline

  attr_accessor :name, :start_immediately, :delay, :actions

  def initialize(name, start_immediately: true)
    @name, @start_immediately = name, start_immediately
    @actions = []
    $project.add_timeline(self)
    @hell = $project.hell_system
    @light = $project.light
  end

  def reset
    action = Action.new(timeline: self)
    action.start_timer
    action
  end

  def stop
    action = Action.new(timeline: self)
    action.stop_timer
    action
  end

  def move_cave(x: 0, y: 0, z: 0, string: nil, duration: 1.0, delay: 0.0)
    action = Action.new(delay: delay, duration: duration)
    action.move_cave_rel(x: x, y: y, z: z, string: string)
    @actions << action

    @actions << @hell.move_distance(x: x, y: y, z: z, duration: duration, delay: delay)
    @actions << @light.move_distance(x: x, y: y, z: z, duration: duration, delay: delay)

  end

end
