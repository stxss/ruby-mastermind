# frozen_string_literal: true

module TextStyles
  RGB_COLOR_MAP = {
    black:       "0;0;0",
    white:       "211;215;207",
    cyan:        "139;233;253",
    teal:        "20;72;69",
    green:       "47;70;27",
    light_green: "158;206;106",
    dark_green:  "38;156;90",
    pink:        "247;118;142",
    red:         "129;19;9",
    dark_red:    "190;28;40",
    light_blue:  "122;162;247",
    blue:        "9;57;159",
    yellow:      "224;175;104",
    violet:      "94;84;142",
    thistle:     "199;182;221",
    mauve:       "231;198;255",
    orange:      "171;71;0",
    gray:        "65;65;58"
  }.freeze

  refine String do
    def fg_color(color_name)
      rgb_val = RGB_COLOR_MAP[color_name]
      "\e[38;2;#{rgb_val}m#{self}\e[0m"
    end

    def bg_color(color_name)
      rgb_val = RGB_COLOR_MAP[color_name]
      "\e[48;2;#{rgb_val}m#{self}\e[0m"
    end

    def bold
      "\033[1m#{self}\033[0m"
    end

    def dim
      "\033[2m#{self}\033[0m"
    end

    def italic
      "\033[3m#{self}\033[0m"
    end

    def underlined
      "\033[4m#{self}\033[0m"
    end

    def reverse
      "\033[7m#{self}\033[0m"
    end

    def blink
      "\033[5m#{self}\033[0m"
    end
  end
end

# Codes for the colors provided in https://www.codeproject.com/Articles/5329247/How-to-change-text-color-in-a-Linux-terminal
# Other codes from https://askubuntu.com/questions/558280/changing-colour-of-text-and-background-of-terminal
# As well as https://dev.to/joshdevhub/terminal-colors-using-ruby-410p
