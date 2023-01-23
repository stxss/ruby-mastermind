
require './text_styles'

# Class for the colored tiles
class Tile
    using TextStyles

    def initialize
    end

    def self.red
        "#{' 1 '.bold.bg_color(:red)}"
    end

    def self.green
        "#{' 2 '.bold.bg_color(:green)}"
    end

    def self.blue
        "#{' 3 '.bold.bg_color(:blue)}"
    end

    def self.orange
        "#{' 4 '.bold.bg_color(:orange)}"
    end

    def self.violet
        "#{' 5 '.bold.bg_color(:violet)}"
    end

    def self.teal
        "#{' 6 '.bold.bg_color(:teal)}"
    end

    def self.blank
        "#{' 0 '.bold.bg_color(:gray)}"
    end
end
