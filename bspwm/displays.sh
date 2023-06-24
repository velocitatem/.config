

# if we have two monitors, run one command and if just one monitor, run another command
#  bspc monitor -d I II III IV V VI VII VIII IX X
MONITOR_COUNT=$(xrandr | grep -c " connected ")
if [ $MONITOR_COUNT -eq 2 ]; then
    xrandr --output DP1 --mode 1920x1080 --above eDP1 --rotate normal --output eDP1 --primary --mode 1920x1080 --rotate normal
    bspc monitor DP1 -d I II IV VI
    bspc monitor eDP1 -d III V VII VIII IX X
else
    xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
    # workspaces I II III IV V VI VII VIII IX X on eDP1
    bspc monitor eDP1 -d I II III IV V VI VII VIII IX X
fi
