require_relative 'cave_object'


class Image < CaveObject

  attr_reader :file_path

  def initialize(name, visible: true,
    lighting: false,
    clickthrough: true,
    aroundselfaxis: false,
    scale: 1,
    position: "(0, 0, 0)",
    relative_to: "Center",
    file_path:)

    super(name, visible: visible,
      lighting: lighting,
      clickthrough: clickthrough,
      aroundselfaxis: aroundselfaxis,
      scale: scale,
      position: position,
      relative_to: relative_to)

    @file_path = file_path

  end

  def is_image?
    true
  end

end
