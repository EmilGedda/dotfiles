#!/bin/bash

SCRIPT=$(realpath -s "$0")

function gen() {

    echo Creating udev rules: /etc/udev/rules.d/powersave.rules
	cat > /etc/udev/rules.d/powersave.rules <<- EOF

		SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="$SCRIPT ac"
		SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="$SCRIPT bat"

	EOF

    echo Creating systemd service file: /usr/lib/systemd/system/resume-governaut.service
    cat > /usr/lib/systemd/system/resume-governaut.service <<- EOF

		[Unit]
		Description=Local system resume actions
		After=suspend.target

		[Service]
		Type=simple
		ExecStart="$SCRIPT"

		[Install]
		WantedBy=suspend.target

	EOF

    echo Enabling the resume-governaut systemd service
    systemctl enable resume-governaut.service

}

DISCHARGING=-1

case "$1" in
	"gen")
		gen
		exit 0
		;;
	"ac")
		DISCHARGING=0
		;;
	"bat")
		DISCHARGING=1
		;;
esac

if (( DISCHARGING < 0 ));  then
	echo Auto detecting battery status...
	upower -i $(upower -e | grep battery) | grep -qE "state:\s+charging"
	DISCHARGING=$?
fi

if (( DISCHARGING ==  1 )); then
	echo "Discharging, setting governor to powersave"
	cpupower frequency-set -g powersave
elif (( DISCHARGING == 0)); then
	echo "AC plugged in, setting governor to performance"
	cpupower frequency-set -g performance
fi

