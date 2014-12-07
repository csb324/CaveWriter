###### TYPES OF BUTTONS / TYPES OF ACTIONS #########
# jump_then_fall
# jump_then_land(height_of_platform)
# run(distance)
# run_into_something
# run_and_fall(distance, height)


require_relative '../lib/text'
require_relative '../lib/group'
require_relative 'hell'

class Button < Text

  $INDEX = 0
  $RUNNING_SPEED = 5.0

  attr_reader :group, :timeline, :system, :index

  def initialize(timeline, group, text)
    @group = group
    @timeline = timeline
    @system = group.system
    @index = group.index

    super("#{text}_#{@index}")
    set_content(text, font: "PressStart2P.ttf")

    @group.add_member(self)
    @timeline.actions << @group.hide

    link_start(timeline)
    $INDEX += 1
  end

  def show_buttons_again(delay)
    @timeline.actions << @system.list[@index].show(delay: delay)
  end

  def show_next_buttons(delay)
    @timeline.actions << @system.list[@index + 1].show(delay: delay) if @system.list[@index + 1]
  end

end

class ButtonGroup < Group

  attr_reader :index, :system

  def initialize(system)
    super("button_group_#{$INDEX}")

    @system = system
    @index = system.list.length
    @system.add(self)

  end

  def add_or_button
    or_button = Text.new("or_#{@index}")
    or_button.set_content("OR", font: "PressStart2P.ttf")
    or_button.set_position(x: 0, y: 1, z: -4)
    add_member(or_button)
  end

  def move_up
    move_distance(y: 3)
  end

end

class ButtonSystem

  attr_reader :list, :hell_system

  def initialize(hell_system, groups)
    @timeline = Timeline.new("hide_all_buttons")
    @list = []
    @hell_system = hell_system

    groups.times do
      ButtonGroup.new(self)
    end
  end

  def add(group)
    if @list.length > 0
      @timeline.actions << group.hide
    end

    @list << group
  end
end

class BeginButton < Button

  def initialize(group)
    timeline = Timeline.new("START_EVERYTHING", start_immediately: false)

    super(timeline, group, "BEGIN")
    set_position(x: 0, y: 1, z: -4)


    show_next_buttons(1.0)
  end

end

class JumpThenFall < Button

  def initialize(group, mystery_box: nil)
    timeline = Timeline.new("jumping#{$INDEX}", start_immediately: false)
    timeline.move_cave(y: 5)
    timeline.move_cave(y: -5, delay: 1.0)

    if mystery_box
      timeline.actions << mystery_box.particles.show(delay: 1.0)
      timeline.actions << mystery_box.particles.hide(delay: 6.0)
    end

    super(timeline, group, "JUMP")
    set_position(x: 1, y: 1, z: -4)

    show_buttons_again(2.0)

  end
end

class JumpThenLand < Button

  def initialize(group, height_of_platform:)
    timeline = Timeline.new("jump_land#{$INDEX}", start_immediately: false)

    timeline.move_cave(y: (height_of_platform * 2) + 2, z: -2)

    timeline.move_cave(y: -2, z: -1, delay: 1.0, duration: 0.3)


    super(timeline, group, "JUMP")


    @system.list.each do |buttons|
      timeline.actions << buttons.move_distance(y: height_of_platform * 2, z: -3, duration: 0)
    end

    set_position(x: 1, y: 1, z: -4)

    show_next_buttons(2.0)

  end

end

class JumpOnEnemy < Button

  def initialize(group, enemy)
    timeline = Timeline.new("jump_enemy#{$INDEX}", start_immediately: false)
    timeline.move_cave(y: 6, z: -2)
    timeline.move_cave(y: -6, z: -2, delay: 1.0)
    timeline.move_cave(z: 4, delay: 2.0)

    timeline.actions << enemy.body.hide(duration: 1.0)

    super(timeline, group, "JUMP")
    set_position(x: 1, y: 1, z: -4)

    show_next_buttons(4.0)
  end

end

class Run < Button

  def initialize(group, block_distance:)
    timeline = Timeline.new("running#{$INDEX}", start_immediately: false)
    duration = block_distance / $RUNNING_SPEED
    timeline.move_cave(z: (block_distance * -2), duration: duration)

    super(timeline, group, "RUN")

    group.add_or_button
    set_position(x: -1, y: 1, z: -4)


    @system.list.each do |buttons|
      timeline.actions << buttons.move_distance(z: block_distance * -2, duration: 0)
    end

    show_next_buttons(duration)
  end
end

class RunIntoSomething < Button

  def initialize(group, block_distance:, enemy: false)
    timeline = Timeline.new("run_into_smth#{$INDEX}", start_immediately: false)
    running_duration = block_distance / $RUNNING_SPEED

    timeline.move_cave(z: block_distance * -2, duration: running_duration)
    timeline.move_cave(z: block_distance * 2, delay: running_duration + 0.1, duration: running_duration)

    super(timeline, group, "RUN")

    if enemy
      timeline.actions << @system.hell_system.show(duration: 1.0, delay: running_duration * 2)
      timeline.actions << @system.hell_system.hide(duration: 1.0, delay: (running_duration * 2) + 5)
      timeline.actions << enemy.failure_message.show(duration: 0.6, delay: (running_duration * 2) + 5)
      timeline.actions << enemy.failure_message.hide(duration: 0.6, delay: (running_duration * 2) + 15)
      show_buttons_again((running_duration * 2) + 15)
    else
      show_buttons_again(2.0)
    end

    group.add_or_button

    set_position(x: -1, y: 1, z: -4)

  end
end

class RunThenFall < Button

  def initialize(group, initial_distance: 2, block_distance:, block_height:)
    timeline = Timeline.new("running#{$INDEX}", start_immediately: false)

    running_duration = initial_distance / $RUNNING_SPEED
    if initial_distance
      timeline.move_cave(z: initial_distance * -2, duration: running_duration)
    end

    total_distance = initial_distance + block_distance
    running_distance = (block_distance - 1)
    second_running_duration = running_distance / $RUNNING_SPEED

    # falling
    timeline.move_cave(y: block_height * -2, z: -2, duration: 0.3, delay: running_duration)
    # running again
    timeline.move_cave(z: running_distance * -2, duration: second_running_duration, delay: running_duration + 0.3)

    super(timeline, group, "RUN")
    group.add_or_button

    set_position(x: -1, y: 1, z: -4)
    @system.list.each do |buttons|
      timeline.actions << buttons.move_distance(z: total_distance * -2, y: block_height * -2, duration: 0)
    end

    show_next_buttons(running_duration)
  end

end

class FinishButton < Button

  def initialize(group)
    timeline = Timeline.new("finish", start_immediately: false)
    timeline.move_cave(z: -2, duration: 1.0)
    timeline.move_cave(y: 15, duration: 1.0, delay: 1.0)
    timeline.move_cave(y: -15, duration: 1.5, delay: 2.0)

    thanks = Text.new("thanks", visible: false)
    thanks.set_content("KEEP PLAYING?", font: "PressStart2P.ttf")
    thanks.set_position(z: -167, y: 1)

    yes = Text.new("yes", visible: false)
    yes.set_content("YES or YES", font: "PressStart2P.ttf")
    yes.set_position(z: -167)

    yes.restart_on_click

    timeline.move_cave(z: -9, duration: 1.0, delay: 3.5)

    timeline.actions << thanks.show(delay: 4.0)
    timeline.actions << yes.show(delay: 5.0, duration: 1.0)

    super(timeline, group, "JUMP")
    set_position(x: 1, y: 1, z: -4)

  end
end
