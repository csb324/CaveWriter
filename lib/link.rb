require_relative 'timeline'
require_relative 'action'

class Link

  attr_accessor :enabled, :remain_enabled, :color, :selected_color, :actions

  def initialize(enabled: true, remain_enabled: true, color: "255, 255, 255", selected_color: "255, 255, 255")
    @enabled, @remain_enabled, @color, @selected_color, @clicks_needed = enabled, remain_enabled, color, selected_color
    @actions = []
  end

  def start_timeline(timeline, clicks_needed: :any)
    start = {action: timeline.reset, clicks_needed: clicks_needed}
    @actions.push(start)
  end

  def restart_cave_link

    restart = Action.new
    restart.restart_cave

    hash = {action: restart, clicks_needed: :any}

    @actions.push(hash)

  end

end
