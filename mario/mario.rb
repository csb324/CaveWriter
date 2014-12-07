require_relative '../lib/xml_writer'
require_relative 'button'
require_relative 'mystery_box'
require_relative 'hill'
require_relative 'hell'
require_relative 'enemy'
require_relative 'cloud'
require_relative 'ending'

class Mario

  def initialize
    @project = Project.new("mario_final")
    $project = @project

    $project.global[:color] = "92, 148, 252"
    $project.hell_system = Hell.new
    $project.add_light

    @i = 0
    @system = ButtonSystem.new($project.hell_system, 17)
    BeginButton.new(@system.list[0])

    @initial = Timeline.new("initial")
    @initial.move_cave(z: -3)

    @fall_and_bounce = ParticleActionList.new("listtt")
    @fall_and_bounce.set_max_age(150)
    @fall_and_bounce.set_cylinder_velocity(radius: 0.1)

    @fall_and_bounce.add_fall
    @fall_and_bounce.add_bounce_on_floor
  end

  def center(number1, number2)
    (number1 + number2).to_f / 2
  end

  def run(block_distance)
    timeline = Timeline.new("running_#{@i}", start_immediately: false)
    timeline.move_cave(z: (block_distance * -2))

    @i += 1
    timeline
  end

  def ground(starts_at_block, block_depth)
    dirt = Text.new("dirt_#{@i}", color: "200,76,12", scale: 100)
    dirt.set_position(x: 0, y: -6.5, z: starts_at_block * 2)
    dirt.set_content("-")
    @i += 1
    dirt.feet_deep= block_depth * 2
  end

  def pipe(center_z, block_height)
    height_in_feet = block_height * 2
    top = height_in_feet - 4
    bottom = -4

    lip = Text.new("pipe_#{@i}_lip", color: "122, 209, 69", scale: 30)
    lip.set_content("O")
    lip.feet_deep = 2
    lip.set_position(x: 0, y: (top - 2), z: center_z * -2)
    lip.set_rotation(axis: "x", angle: 90)

    body = Text.new("pipe_#{@i}_body", color: "122, 209, 69", scale: 25)
    body.set_content("O")
    body.feet_deep = height_in_feet - 2
    body.set_position(x: 0, y: bottom, z: center_z * -2)
    body.set_rotation(axis: "x", angle: 90)
    @i += 1
  end

  def brick(front_z, block_height)

    real_height = (block_height * 2) - 4
    real_depth = (front_z * -2)

    bricks = Text.new("bricks_#{@i}", color: "220,35,23", scale: 10)
    bricks.set_position(x: 0, y: real_height, z: real_depth)
    bricks.set_content("x", font: "Wingdings.ttf")
    bricks.feet_deep = 2

    @i += 1
  end

  def first_pass
    ground(0, 70)
    5.times do
      ButtonGroup.new(system)
    end

    # begin
    Run.new(system.list[0], block_distance: 13)
    JumpThenFall.new(system.list[0])

    # either get the box or keep going
    mystery_box(13, 3)

    brick(17, 3)
    # mystery_box(18, 3)
    brick(19, 3)
    # mystery_box(20, 3)
    brick(21, 3)

    pipe(26, 2)
    pipe(36, 3)
    pipe(44, 4)
    pipe(55, 4)

    brick(61, 5)

    writer = XmlWriter.new($project)
    writer.save
  end

  def test
    ground(0, 70)
    # buttons
    group1 = ButtonGroup.new(@system)
    group2 = ButtonGroup.new(@system)
    group3 = ButtonGroup.new(@system)

    Run.new(group1, block_distance: 20)
    JumpThenFall.new(group1)

    Run.new(group2, block_distance: 10)
    JumpThenLand.new(group2, height_of_platform: 3)
    brick(21, 3)
    brick(22, 3)
    brick(23, 3)

    RunThenFall.new(group3, block_distance: 3, block_height: 3)
    JumpThenFall.new(group3)

    brick(15, 4)
    brick(35, 4)

    writer = XmlWriter.new($project)
    writer.save
  end

  def particle_test

    ground(0, 70)
    Hill.new("words words words words go to class do school be good at life and things yeah words")
    Hill.new("This hill is smaller and goes on the other side", side: :right)


    Run.new(@system.list[1], block_distance: 18)
    JumpThenFall.new(@system.list[1])

    brick(19, 6)
    box1 = MysteryBox.new(20, 6, "hey", @fall_and_bounce)
    brick(21, 6)

    Run.new(@system.list[2], block_distance: 5)
    JumpThenFall.new(@system.list[2], mystery_box: box1)

    writer = XmlWriter.new($project)
    writer.save

  end

  def enemy_test

    ground(0, 70)
    Run.new(@system.list[1], block_distance: 18)
    JumpThenFall.new(@system.list[1])

    pipe(20, 2)
    RunIntoSomething.new(@system.list[2], block_distance: 2)
    JumpThenLand.new(@system.list[2], height_of_platform: 2)

    RunThenFall.new(@system.list[3], block_distance: 4, block_height: 2)
    JumpThenFall.new(@system.list[3])

    enemy = Enemy.new(
        name: "piano recital",
        failure: "you forget how the song goes\nin the middle. you're mortified.\neveryone forgets about it within a week.",
        z_position: 30)

    RunIntoSomething.new(@system.list[4], block_distance: 2, enemy: enemy)
    JumpOnEnemy.new(@system.list[4], enemy)

    writer = XmlWriter.new($project)
    writer.save

  end

  def generate_random_hills(start, finish)
    distance = finish - start
    num_of_hills = distance / 6
    phrases = ["do not listen to Britney Spears. she is a bad influence",
      "press START for options",
      "do not watch cartoon network",
      "do not drink soda",
      "limit screen time to 2 hours per day",
      "do not run away to join the circus",
      "do not fall in with the wrong crowd.",
      "do not worry. everything will be fine.",
      "do not forget your notebook",
      "do not fake an illness to skip gym",
      "do not take an after-school job.",
      "do take an after-school volunteer opportunity",
      "do not pierce your ears until you turn twelve, no matter what",
      "do not sit in the front seat",
      "do not sleep in past 10",
      "do not stay home from school unless you have a fever",
      "do not play in the street",
      "do not stay up all night texting",
      "do not read a book under the table during class.",
      "do the extra credit projects."
    ]

    z_position = start
    num_of_hills.times do
        if rand() > 0.5
            side = :right
        else
            side = :left
        end

        Hill.new(phrases.sample, side: side, z_position: z_position * -2)
        Cloud.new(phrases.sample, z_position: z_position * -2)
        z_position += [7, 5, 6].sample
    end
  end

  def complete

    ground(0, 280)
    generate_random_hills(0, 70)

    box1 = MysteryBox.new(13, 6, @fall_and_bounce)
    Run.new(@system.list[1], block_distance: 10)
    JumpThenFall.new(@system.list[1])

    Run.new(@system.list[2], block_distance: 6)
    JumpThenFall.new(@system.list[2], mystery_box: box1)

    brick(18, 6)
    box2 = MysteryBox.new(19, 6, @fall_and_bounce)
    JumpThenFall.new(@system.list[3], mystery_box: box2)
    Run.new(@system.list[3], block_distance: 2)
    brick(20, 6)
    box3 = MysteryBox.new(21, 6, @fall_and_bounce)
    JumpThenFall.new(@system.list[4], mystery_box: box3)
    Run.new(@system.list[4], block_distance: 8)
    brick(22, 6)

    pipe(29, 2)
    JumpThenLand.new(@system.list[5], height_of_platform: 2)
    RunIntoSomething.new(@system.list[5], block_distance: 1)

    JumpThenFall.new(@system.list[6])
    RunThenFall.new(@system.list[6], block_distance: 7, block_height: 2)

    pipe(39, 3)

    JumpThenLand.new(@system.list[7], height_of_platform: 3)
    RunIntoSomething.new(@system.list[7], block_distance: 1)
    @initial.actions << @system.list[7].move_distance(z: 3)

    JumpThenFall.new(@system.list[8])
    RunThenFall.new(@system.list[8], block_distance: 4, block_height: 3)

    enemy = Enemy.new(
        name: "piano recital",
        failure: "you forget how the song goes\nin the middle. you're mortified.\neveryone forgets about it within a week.",
        z_position: 45)

    JumpOnEnemy.new(@system.list[9], enemy)
    RunIntoSomething.new(@system.list[9], block_distance: 2, enemy: enemy)

    Run.new(@system.list[10], block_distance: 8)
    JumpThenFall.new(@system.list[10])

    pipe(55, 4)

    JumpThenLand.new(@system.list[11], height_of_platform: 4)
    RunIntoSomething.new(@system.list[11], block_distance: 2)
    @initial.actions << @system.list[11].move_distance(z: 2)

    JumpThenFall.new(@system.list[12])
    RunThenFall.new(@system.list[12], block_distance: 7, block_height: 4)

    enemy2 = Enemy.new(
      name: "50 states project",
      failure: "put it off until the last minute.\nyou mom drives you to the craft store\nand your dad helps you glue gun a polar bear\nto a winter hat. There. It’s Alaska.",
      z_position: 65)

    RunIntoSomething.new(@system.list[13], block_distance: 2, enemy: enemy2)
    JumpOnEnemy.new(@system.list[13], enemy2)

    Run.new(@system.list[14], block_distance: 9)
    JumpThenFall.new(@system.list[14])

    box4 = MysteryBox.new(73, 6, @fall_and_bounce)

    Run.new(@system.list[15], block_distance: 5)
    JumpThenFall.new(@system.list[15], mystery_box: box4)

    Ending.new(80)

    FinishButton.new(@system.list[16])
    RunIntoSomething.new(@system.list[16], block_distance: 2)

    writer = XmlWriter.new($project)
    writer.save

  end

end

Mario.new.complete

