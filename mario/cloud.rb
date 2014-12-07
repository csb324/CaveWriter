require_relative '../lib/text'

class Cloud < Text

  def initialize(content, z_position: 0)

    super("cloud", scale: 1.9)
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

    set_content(text, font: "omnesbla.ttf")
    set_position(x: rand(18) - 9, y: rand(8) + 6, z: z_position)

    image = Image.new("cloud", file_path: "./cloud.png", scale: 3)
    image.set_position(x: rand(40) - 20, y: rand(10) + 8, z: z_position - 6)

  end

end
