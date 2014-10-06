require_relative 'action'
require 'pry'

class Timeline

  attr_accessor :name, :start_immediately, :delay, :actions

  def initialize(name, start_immediately: true)
    @name, @start_immediately = name, start_immediately
    @actions = []
    $project.timelines << self
  end

  def reset
    action = Action.new(timeline: self)
    action.start_timer
    action
  end

end
