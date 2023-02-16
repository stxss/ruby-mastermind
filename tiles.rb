# frozen_string_literal: true

require_relative "./text_styles"

# Class for the colored tiles
class Tile
  using TextStyles

  def self.red
    " 1 ".bold.bg_color(:red).to_s
  end

  def self.green
    " 2 ".bold.bg_color(:green).to_s
  end

  def self.blue
    " 3 ".bold.bg_color(:blue).to_s
  end

  def self.orange
    " 4 ".bold.bg_color(:orange).to_s
  end

  def self.violet
    " 5 ".bold.bg_color(:violet).to_s
  end

  def self.teal
    " 6 ".bold.bg_color(:teal).to_s
  end

  def self.blank
    " 0 ".bold.bg_color(:gray).to_s
  end

  def self.empty_tile
    " \u{25ef} "
  end

  def self.color_only
    "\u{25cf}".fg_color(:pink)
  end

  def self.place_color
    "\u{25cf}".fg_color(:dark_green)
  end

  def self.empty_hint
    "\u{25cb}"
  end
end
