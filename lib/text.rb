require_relative 'cave_object'

class Text < CaveObject

  attr_accessor :text_content, :horiz_align, :vert_align, :font, :depth

  def set_content(text_content, horiz_align: "center", vert_align: "center", font: "Courier.ttf", depth: 1)
    @text_content, @horiz_align, @vert_align, @font, @depth = text_content, horiz_align, vert_align, font, depth
  end

  def is_text?
    true
  end

end
