require_relative '../lib/text'

class Hill < Text

  def initialize(content, side: :left, z_position: 0, offset: 0)

    super("hill", color: "153, 255, 102", scale: 1.9)
    pieces = content.split(" ")
    text_strings = []
    text_strings << pieces[0...2].join(" ")
    text_strings << pieces[2...5].join(" ")

    if pieces.length > 5
      text_strings << pieces[5...8].join(" ")
    end
    if pieces.length > 8
      text_strings << pieces[8...13].join(" ")
    end
    if pieces.length > 13
      text_strings << pieces[18...pieces.length].join(" ")
    end

    text = text_strings.join("\n")

    set_content(text, font: "PressStart2P.ttf")
    if side == :left
      set_position(x: -6 - offset, y: -3, z: z_position)
      set_rotation(axis: "y", angle: 90)
    elsif side == :right
      set_position(x: 6 + offset, y: -3, z: z_position)
      set_rotation(axis: "y", angle: -90)
    end

  end

end
