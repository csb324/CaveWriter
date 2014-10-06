class Plane

  attr_accessor :x1, :x2, :y1, :y2, :z1, :z2, :text, :scale, :color,
    :density, :jitter, :font, :group

  attr_reader :flatplane, :triangle

  def initialize(
    name,
    x1: nil, y1: nil, z1: nil,
    x2: nil, y2: nil, z2: nil,
    text:,
    scale: 1,
    color: "255, 255, 255",
    density: 3,
    jitter: false,
    triangle: false,
    font: "Courier.ttf")

    @text, @scale, @color, @density, @jitter, @triangle, @font =
      text, scale, color, density, jitter, triangle, font

    @group = Group.new(name)

    if (x1 && x2)
      if x1 > x2
        @x1, @x2 = x2, x1
      else
        @x1, @x2 = x1, x2
      end

      if (y1 && y2)
        if y1 > y2
          @y1, @y2 = y2, y1
        else
          @y1, @y2 = y1, y2
        end
        @z1 = (z1 != nil ? z1 : z2)
        @flatplane = :z
      elsif (z1 && z2)
        if z1 > z2
          @z1, @z2 = z2, z1
        else
          @z1, @z2 = z1, z2
        end
        @y1 = (y1 != nil ? y1 : y2)
        @flatplane = :y
      end
    else
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
      @x1 = (x1 != nil ? x1 : x2)
      @flatplane = :x
    end

    build(@triangle)

  end

  def build(triangle)

    xpos = @x1
    ypos = @y1
    zpos = @z1

    case @flatplane
    when :x

      y_units.times do
        z_units.times do


          if triangle
            if zpos < ((@z2 - @z1)/(@y2 - @y1) * (ypos - @y1) + @z1)
              text = create_text(x: xpos, y: ypos, z: zpos)
            end
          else
            text = create_text(x: xpos, y: ypos, z: zpos)
          end
          text.set_rotation(axis: "y", angle: -90) unless (@jitter || !text)
          zpos += space
        end
        zpos = @z1
        ypos += space
      end

    when :y

      x_units.times do
        z_units.times do
          if triangle
            if zpos < ((@z2 - @z1)/(@x2 - @x1) * (xpos - @x1) + @z1)
              text = create_text(x: xpos, y: ypos, z: zpos)
            end
          else
            text = create_text(x: xpos, y: ypos, z: zpos)
          end

          text.set_rotation(axis: "x", angle: -90) unless (@jitter || !text)
          zpos += space
        end
        zpos = @z1
        xpos += space
      end

    when :z

      x_units.times do
        y_units.times do

          if triangle
            if ypos < ((@y2 - @y1)/(@x2 - @x1)*(xpos - @x1) + @y1)
              create_text(x: xpos, y: ypos, z: zpos)
            end

          else
            create_text(x: xpos, y: ypos, z: zpos)
          end

          ypos += space
        end
        ypos = @y1
        xpos += space
      end

    else
      puts "PROBLEM - no flat plane???"
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

    @group.add_member(word)
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
