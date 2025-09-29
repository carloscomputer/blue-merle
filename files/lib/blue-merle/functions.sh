#!/bin/sh

# Finde den richtigen AT-Port automatisch
FIND_AT_PORT() {
    for dev in /dev/ttyUSB*; do
        echo -e "AT+GSN\r" > "$dev" &
        sleep 1
        out=$(timeout 2 cat < "$dev" | grep -E '^[0-9]{14,17}$')
        if [ -n "$out" ]; then
            echo "$dev"
            return 0
        fi
    done
    return 1
}

# Wrapper für AT-Befehle
GL_MODEM_AT() {
    port=$(FIND_AT_PORT)
    if [ -z "$port" ]; then
        echo "Kein AT-Port gefunden!" >&2
        return 1
    fi
    echo -e "$1\r" > "$port" &
    sleep 1
    timeout 2 cat < "$port"
}

READ_IMEI() {
    GL_MODEM_AT "AT+GSN" | grep -w -E "[0-9]{14,17}"
}

READ_IMSI() {
    GL_MODEM_AT "AT+CIMI" | grep -w -E "[0-9]{6,15}"
}

CHECK_ABORT() {
    if [ -f /tmp/sim_change_switch ]; then
        state=$(cat /tmp/sim_change_switch)
        if [ "$state" = "off" ]; then
            mcu_send_message "Switch was pulled. Aborting."
            exit 1
        fi
    fi
}
