#!/bin/sh

tx() {
  terminix "$@"
  sleep 0.5
}

xd1() {
  xdotool key Down Down Down Down Insert Insert Insert Insert
}
xd2() {
  xdotool key F9 l Down Down
}
xd3() {
  xdotool key Down F5 Down Down
}
xd4() {
  xdotool key F5
}

spring="mc -S seasons-spring16M /bin /etc"
summer="mc -S seasons-summer16M /bin /etc"
autumn="mc -S seasons-autumn16M /bin /etc"
winter="mc -S seasons-winter16M /bin /etc"

terminix --geometry 80x72 -x "$spring" &
sleep 1.5
xd1
tx -a session-add-down -x "$spring"
xd2
tx -a session-add-down -x "$spring"
xd3
tx -a session-add-down -x "$spring"
xd4

tx -a session-switch-to-terminal-up
tx -a session-switch-to-terminal-up
tx -a session-switch-to-terminal-up

tx -a session-add-right -x "$summer"
xd1
tx -a session-switch-to-terminal-down
tx -a session-add-right -x "$summer"
xd2
tx -a session-switch-to-terminal-down
tx -a session-add-right -x "$summer"
xd3
tx -a session-switch-to-terminal-down
tx -a session-add-right -x "$summer"
xd4

tx -a session-switch-to-terminal-up
tx -a session-switch-to-terminal-up
tx -a session-switch-to-terminal-up

tx -a session-add-right -x "$autumn"
xd1
tx -a session-switch-to-terminal-down
tx -a session-add-right -x "$autumn"
xd2
tx -a session-switch-to-terminal-down
tx -a session-add-right -x "$autumn"
xd3
tx -a session-switch-to-terminal-down
tx -a session-add-right -x "$autumn"
xd4

tx -a session-switch-to-terminal-up
tx -a session-switch-to-terminal-up
tx -a session-switch-to-terminal-up

tx -a session-add-right -x "$winter"
xd1
tx -a session-switch-to-terminal-down
tx -a session-add-right -x "$winter"
xd2
tx -a session-switch-to-terminal-down
tx -a session-add-right -x "$winter"
xd3
tx -a session-switch-to-terminal-down
tx -a session-add-right -x "$winter"
xd4
