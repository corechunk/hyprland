## Basic
    # Fullscreen screenshot, copy to clipboard
    #grim - | wl-copy

    # Region (select area) screenshot, copy to clipboard
    #grim -g "$(slurp)" - | wl-copy

    # Region screenshot and open for annotation/editing (Swappy)
    #grim -g "$(slurp)" - | swappy -f -

    # Region screenshot, save to Pictures folder with timestamp
    #grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%s).png

    # Fullscreen screenshot, save to Pictures folder with timestamp
    #grim ~/Pictures/screenshot-$(date +%s).png


grim - | wl-copy
