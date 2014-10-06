require_relative 'text'
require_relative 'group'
require_relative 'plane'

class BoxOfText

  attr_accessor :x1, :x2, :y1, :y2, :z1, :z2, :text, :scale, :color,
    :density, :jitter, :font, :group

  def initialize(
    name,
    x1: 0.0, y1: 0.0, z1: 0.0,
    x2: 1, y2: 1, z2: 1,
    text:,
    scale: 1,
    color: "255, 255, 255",
    density: 3,
    jitter: false,
    font: "Courier.ttf")

    @x1, @x2, @y1, @y2, @z1, @z2, @text,
      @scale, @color, @density, @jitter, @font =
      x1, x2, y1, y2, z1, z2, text,
      scale, color, density, jitter, font

    @group = Group.new(name)

    if x1 > x2
      @x1, @x2 = x2, x1
    else
      @x1, @x2 = x1, x2
    end
    if y1 > y2
      @y1, @y2 = y2, y1
    else
      @y1, @y2 = y1, y2
    end
    if z1 > z2
      @z1, @z2 = z2, z1
    else
      @z1, @z2 = z1, z2
    end
  end

  def box
    top
    bottom
    front
    back
    sides
  end

  def top
    top = Plane.new("top_of_box_#{@text}", x1: @x1, x2: @x2, y1: @y2, z1: @z1, z2: @z2, text: @text, scale: @scale, color: @color, density: @density, jitter: @jitter, font: @font)
    @group.add_member(top.group)
  end

  def bottom
    bottom = Plane.new("bottom_of_box_#{@text}", x1: @x1, x2: @x2, y1: @y1, z1: @z1, z2: @z2, text: @text, scale: @scale, color: @color, density: @density, jitter: @jitter, font: @font)
    @group.add_member(bottom.group)
  end

  def front
    front = Plane.new("front_of_box_#{@text}", x1: @x1, x2: @x2, y1: @y1, y2: @y2, z1: @z2, text: @text, scale: @scale, color: @color, density: @density, jitter: @jitter, font: @font)
    @group.add_member(front.group)
  end

  def back
    back = Plane.new("back_of_box_#{@text}", x1: @x1, x2: @x2, y1: @y1, y2: @y2, z1: @z1, text: @text, scale: @scale, color: @color, density: @density, jitter: @jitter, font: @font)
    @group.add_member(back.group)
  end

  def sides
    left = Plane.new("left_side_of_box_#{@text}", x1: @x1, y1: @y1, y2: @y2, z1: @z1, z2: @z2, text: @text, scale: @scale, color: @color, density: @density, jitter: @jitter, font: @font)
    right = Plane.new("right_side_of_box_#{@text}", x1: @x2, y1: @y1, y2: @y2, z1: @z1, z2: @z2, text: @text, scale: @scale, color: @color, density: @density, jitter: @jitter, font: @font)
    @group.add_member(left.group)
    @group.add_member(right.group)
  end

  def legs
    leg_group = Group.new("legs_of_#{text}_box")
    y_pos = @y1
    y_units.times do
      text1 = create_text(x: @x1, y: y_pos, z: @z1)
      text2 = create_text(x: @x1, y: y_pos, z: @z2)
      text3 = create_text(x: @x2, y: y_pos, z: @z1)
      text4 = create_text(x: @x2, y: y_pos, z: @z2)
      legs = [text1, text2, text3, text4]

      legs.each do |leg|
        leg.set_rotation(axis: "z", angle: 90) unless @jitter
        leg_group.add_member(leg)
      end
      y_pos += space
    end
    @group.add_member(leg_group)
  end

  private

  def create_text(x:, y:, z:)
    object_name = "#{x}_#{y}_#{z}_#{text}"
    word = Text.new(object_name, scale: @scale, color: @color, lighting: true)
    word.set_content(@text, font: @font)
    word.set_position(x: x, y: y, z: z)

    if @jitter == "free"
      word.set_rotation(axis: ["x", "y", "z"].sample, angle: rand(180))
    elsif @jitter == "90degree"
      word.set_rotation(axis: ["x", "y", "z"].sample, angle: [0, 90, 180, 270].sample)
    end
    word
  end

  def space
    @scale.to_f / @density
  end

  def y_units
    ((@y2 - @y1).to_f / space).abs.ceil
  end

end
