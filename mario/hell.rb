class Hell < ParticleSystem

  def initialize
    super("hell", visible: false, max_particles: 1000)

    list = ParticleActionList.new("hell_list", rate: 10.0)
    list.set_cylinder_source
    list.set_max_age(30)

    falling = ParticleAction.new(list)
    falling.fall_down(0.1)

    connect_actions(list)
    connect_group(word_group)
    set_position(y: 4, z: 4)

  end

  def word_group

    punishments = [
      "inadequate",
      "everything’s been handed to you",
      "ungrateful",
      "stupid",
      "not going anywhere",
      "failure",
      "not good enough"
    ]

    group = Group.new("punishment_group")

    punishments.each do |phrase|

      red_value = rand(100) + 140
      blue_and_green_value = rand(50)
      colorstring = "#{red_value}, #{blue_and_green_value}, #{blue_and_green_value}"
      bad = Text.new("punish", color: colorstring, visible: false)
      bad.set_content(phrase)

      group.add_member(bad)

    end

    group

  end


end
