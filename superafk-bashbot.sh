#!/bin/bash

# Set the screen resolution
screen_width=1920
screen_height=1080

# Set the DISPLAY variable
export DISPLAY=:1

# Initialize variables
curr_coords=$(xdotool getmouselocation --shell | awk -F= '/X/ {print $2}';)
afk_counter=0

while true; do
    if [ "$(xdotool getmouselocation --shell | awk -F= '/X/ {print $2}';)" == "$curr_coords" ]; then
        afk_counter=$((afk_counter + 1))
    else
        afk_counter=0
        curr_coords=$(xdotool getmouselocation --shell | awk -F= '/X/ {print $2}';)
    fi

    if [ $afk_counter -gt 5 ]; then
        # Generate random coordinates within the screen boundaries
        x=$((RANDOM % screen_width))
        y=$((RANDOM % screen_height))

        # Add random offset to simulate human mouse movement
        x=$((x + RANDOM % 101 - 50))
        y=$((y + RANDOM % 101 - 50))

        # Ensure generated coordinates are within screen boundaries
        x=$((x < 0 ? 0 : (x > screen_width ? screen_width : x)))
        y=$((y < 0 ? 0 : (y > screen_height ? screen_height : y)))

        # Simulate mouse movement
        xdotool mousemove $x $y
        curr_coords=$(xdotool getmouselocation --shell | awk -F= '/X/ {print $2}';)

        # Simulate occasional mouse clicks
        if [ $((RANDOM % 100)) -lt 5 ]; then
            xdotool click 1
        fi

        # Simulate small mouse movements
        if [ $((RANDOM % 10)) -lt 1 ]; then
            x_offset=$((RANDOM % 21 - 10))
            y_offset=$((RANDOM % 21 - 10))
            xdotool mousemove_relative --sync $x_offset $y_offset
        fi
    fi

    echo "AFK Counter: $afk_counter"
    sleep $(awk -v min=1 -v max=3 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
done
