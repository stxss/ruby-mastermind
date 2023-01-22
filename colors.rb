module Color
    # Foreground colors
    def black
        "\033[30m#{self}\033[0m"
    end

    def dark_red
        "\033[31m#{self}\033[0m"
    end

    def dark_green
        "\033[32m#{self}\033[0m"
    end

    def dark_yellow
        "\033[33m#{self}\033[0m"
    end

    def dark_blue
        "\033[34m#{self}\033[0m"
    end

    def dark_magenta
        "\033[35m#{self}\033[0m"
    end

    def dark_cyan
        "\033[36m#{self}\033[0m"
    end

    def red
        "\033[91m#{self}\033[0m"
    end

    def green
        "\033[92m#{self}\033[0m"
    end

    def orange
        "\033[93m#{self}\033[0m"
    end

    def blue
        "\033[94m#{self}\033[0m"
    end

    def magenta
        "\033[95m#{self}\033[0m"
    end

    def cyan
        "\033[96m#{self}\033[0m"
    end

    # Background colors
    def bg_white
        "\033[97m#{self}\033[0m"
    end

    def bg_black
        "\033[40m#{self}\033[0m"
    end

    def bg_dark_red
        "\033[41m#{self}\033[0m"
    end

    def bg_dark_green
        "\033[42m#{self}\033[0m"
    end

    def bg_dark_yellow
        "\033[43m#{self}\033[0m"
    end

    def bg_dark_blue
        "\033[44m#{self}\033[0m"
    end

    def bg_dark_magenta
        "\033[45m#{self}\033[0m"
    end

    def bg_dark_cyan
        "\033[46m#{self}\033[0m"
    end

    def bg_red
        "\033[101m#{self}\033[0m"
    end

    def bg_green
        "\033[102m#{self}\033[0m"
    end

    def bg_orange
        "\033[103m#{self}\033[0m"
    end

    def bg_blue
        "\033[104m#{self}\033[0m"
    end

    def bg_magenta
        "\033[105m#{self}\033[0m"
    end

    def bg_cyan
        "\033[106m#{self}\033[0m"
    end

    def bg_white
        "\033[107m#{self}\033[0m"
    end

    def bold
        "\033[1m#{self}\033[0m"
    end
end


# Codes for the colors provided in https://www.codeproject.com/Articles/5329247/How-to-change-text-color-in-a-Linux-terminal
