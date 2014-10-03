require_relative 'text'
require_relative 'group'

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

  def triangle
    if @x1 == @x2
      x_pos = @x1
      y_pos = @y1
      y_units.times do
        z_pos = @z1
        z_units.times do
          if z_pos < ((@z2 - @z1)/(@y2 - @y1) * (y_pos - @y1) + @z1)
            text = create_text(x: x_pos, y: y_pos, z: z_pos)
            text.set_rotation(axis: "y", angle: 90) unless @jitter
            @group.add_member(text)
          end
          z_pos += space
        end
        y_pos += space
      end

    elsif @y1 == @y2
      y_pos = @y1
      x_pos = @x1
      x_units.times do
        z_pos = @z1
        z_units.times do
          if z_pos < ((@z2 - @z1)/(@x2 - @x1) * (x_pos - @x1) + @z1)
            text = create_text(x: x_pos, y: y_pos, z: z_pos)
            @group.add_member(text)
          end
          z_pos += space
        end
        x_pos += space
      end

    elsif @z1 == @z2
      z_pos = @z1
      x_pos = @x1
      x_units.times do
        y_pos = @y1
        y_units.times do
          if y_pos < ((@y2 - @y1)/(@x2 - @x1)*(x_pos - @x1) + @y1)
            text = create_text(x: x_pos, y: y_pos, z: z_pos)
            @group.add_member(text)
          end
          y_pos += space
        end
        x_pos += space
      end

    else
      puts "TRIANGLE PROBLEM"
    end
  end

  def top
    x_pos = @x1
    x_units.times do
      z_pos = @z1
      z_units.times do

        text = create_text(x: x_pos, y: @y2, z: z_pos)
        text.set_rotation(axis: "x", angle: -90) unless @jitter

        @group.add_member(text)
        z_pos += space
      end
      x_pos += space
    end
  end

  def bottom
    x_pos = @x1
    x_units.times do
      z_pos = @z1
      z_units.times do
        text = create_text(x: x_pos, y: @y1, z: z_pos)
        @group.add_member(text)
        z_pos += space
      end
      x_pos += space
    end
  end

  def front
    x_pos = @x1
    x_units.times do
      y_pos = @y1
      y_units.times do
        text = create_text(x: x_pos, z: @z2, y: y_pos)
        @group.add_member(text)
        y_pos += space
      end
      x_pos += space
    end
  end

  def back
    x_pos = @x1
    x_units.times do
      y_pos = @y1
      y_units.times do
        text = create_text(x: x_pos, z: @z1, y: y_pos)
        @group.add_member(text)
        y_pos += space
      end
      x_pos += space
    end
  end

  def sides
    y_pos = @y1
    y_units.times do
      z_pos = @z1
      z_units.times do
        both_sides = [@x1, @x2]

        both_sides.each do |x|
          side = create_text(x: x, y: y_pos, z: z_pos)
          side.set_rotation(axis: "y", angle: 90) unless @jitter
          @group.add_member(side)
        end

        z_pos += space
      end
      y_pos += space
    end
  end

  def legs
    y_pos = @y1
    y_units.times do
      text1 = create_text(x: @x1, y: y_pos, z: @z1)
      text2 = create_text(x: @x1, y: y_pos, z: @z2)
      text3 = create_text(x: @x2, y: y_pos, z: @z1)
      text4 = create_text(x: @x2, y: y_pos, z: @z2)
      legs = [text1, text2, text3, text4]

      legs.each do |leg|
        leg.set_rotation(axis: "z", angle: 90) unless @jitter
        @group.add_member(leg)
      end
      y_pos += space
    end
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

  def x_units
    ((@x2 - @x1).to_f / space).abs.ceil
  end

  def y_units
    ((@y2 - @y1).to_f / space).abs.ceil
  end

  def z_units
    ((@z2 - @z1).to_f / space).abs.ceil
  end

end
