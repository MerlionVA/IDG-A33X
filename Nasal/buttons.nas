# A3XX Buttons
# Joshua Davidson (it0uchpods)

#######################################
# Copyright (c) A3XX Development Team #
#######################################

# Resets buttons to the default values
var variousReset = func {
	setprop("/modes/cpt-du-xfr", 0);
	setprop("/modes/fo-du-xfr", 0);
	setprop("/controls/fadec/n1mode1", 0);
	setprop("/controls/fadec/n1mode2", 0);
	setprop("/instrumentation/mk-viii/serviceable", 1);
	setprop("/instrumentation/mk-viii/inputs/discretes/terr-inhibit", 0);
	setprop("/instrumentation/mk-viii/inputs/discretes/gpws-inhibit", 0);
	setprop("/instrumentation/mk-viii/inputs/discretes/glideslope-cancel", 0);
	setprop("/instrumentation/mk-viii/inputs/discretes/momentary-flap-override", 0);
	setprop("/instrumentation/mk-viii/inputs/discretes/momentary-flap3-override", 0);
	# cockpit voice recorder stuff
	setprop("/controls/CVR/power", 0);
	setprop("/controls/CVR/test", 0);
	setprop("/controls/CVR/tone", 0);
	setprop("/controls/CVR/gndctl", 0);
	setprop("/controls/CVR/erase", 0);
	setprop("/controls/switches/cabinfan", 1);
}


var CVR_test = func {
	var parkBrake = getprop("/controls/gear/brake-parking");
	if (parkBrake) {
		setprop("controls/CVR/tone", 1);
		settimer(func() {
			setprop("controls/CVR/tone", 0);
		}, 15);
	}
}

var CVR_master = func {
	var stateL = getprop("/engines/engine[0]/state");
	var stateR = getprop("/engines/engine[1]/state");
	var wowl = getprop("/gear/gear[1]/wow");
	var wowr = getprop("/gear/gear[2]/wow");
	var gndCtl = getprop("/controls/CVR/gndctl");
	var acPwr = getprop("/systems/electrical/bus/ac-ess");
	if (acPwr > 0 and wowl and wowr and (gndCtl or (stateL == 3 or stateR == 3))) {
		setprop("/controls/CVR/power", 1);
	} else if (!wowl and !wowr and acPwr > 0) {
		setprop("/controls/CVR/power", 1);
	} else {
		setprop("/controls/CVR/power", 0);
	}
}

var mcpSPDKnbPull = func {
	setprop("/it-autoflight/input/spd-managed", 0);
	fmgc.ManagedSPD.stop();
	var ias = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt");
	var mach = getprop("/instrumentation/airspeed-indicator/indicated-mach");
	if (getprop("/it-autoflight/input/kts-mach") == 0) {
		if (ias >= 100 and ias <= 360) {
			setprop("/it-autoflight/input/spd-kts", math.round(ias, 1));
		} else if (ias < 100) {
			setprop("/it-autoflight/input/spd-kts", 100);
		} else if (ias > 360) {
			setprop("/it-autoflight/input/spd-kts", 360);
		}
	} else if (getprop("/it-autoflight/input/kts-mach") == 1) {
		if (mach >= 0.50 and mach <= 0.95) {
			setprop("/it-autoflight/input/spd-kts", math.round(mach, 0.001));
		} else if (mach < 0.50) {
			setprop("/it-autoflight/input/spd-kts", 0.50);
		} else if (mach > 0.95) {
			setprop("/it-autoflight/input/spd-kts", 0.95);
		}
	}
}

var mcpSPDKnbPush = func {
	if (getprop("/FMGC/internal/cruise-lvl-set") == 1 and getprop("/FMGC/internal/cost-index-set") == 1) {
		setprop("/it-autoflight/input/spd-managed", 1);
		fmgc.ManagedSPD.start();
	} else {
		gui.popupTip("Please make sure you have set a cruise altitude and cost index in the MCDU.");
	}
}

var mcpHDGKnbPull = func {
	var latmode = getprop("/it-autoflight/output/lat");
	var showhdg = getprop("/it-autoflight/custom/show-hdg");
	if (latmode == 0 or showhdg == 0) {
		setprop("/it-autoflight/input/lat", 3);
		setprop("/it-autoflight/custom/show-hdg", 1);
	} else {
		setprop("/it-autoflight/input/lat", 0);
		setprop("/it-autoflight/custom/show-hdg", 1);
	}
}

var mcpHDGKnbPush = func {
	setprop("/it-autoflight/input/lat", 1);
}

var hdgInput = func {
	var latmode = getprop("/it-autoflight/output/lat");
	if (latmode != 0) {
		setprop("/it-autoflight/custom/show-hdg", 1);
		var hdgnow = getprop("/it-autoflight/input/hdg");
		settimer(func {
			var hdgnew = getprop("/it-autoflight/input/hdg");
			var showhdg = getprop("/it-autoflight/custom/show-hdg");
			if (hdgnow == hdgnew and latmode != 5 and showhdg == 1) {
				settimer(func {
					setprop("/it-autoflight/custom/show-hdg", 0);
				}, 10);
			}
		}, 2);
	}
}

var toggleSTD = func {
	var Std = getprop("/modes/altimeter/std");
	if (Std == 1) {
		var oldqnh = getprop("/modes/altimeter/oldqnh");
		setprop("/instrumentation/altimeter/setting-inhg", oldqnh);
		setprop("/modes/altimeter/std", 0);
	} else if (Std == 0) {
		var qnh = getprop("/instrumentation/altimeter/setting-inhg");
		setprop("/modes/altimeter/oldqnh", qnh);
		setprop("/instrumentation/altimeter/setting-inhg", 29.92);
		setprop("/modes/altimeter/std", 1);
	}
}

var increaseManVS = func {
	var manvs = getprop("/systems/pressurization/outflowpos-man");
	var auto = getprop("/systems/pressurization/auto");
	if (manvs <= 1 and manvs >= 0 and !auto) {
		setprop("/systems/pressurization/outflowpos-man", manvs + 0.001);
	}
}

var decreaseManVS = func {
	var manvs = getprop("/systems/pressurization/outflowpos-man");
	var auto = getprop("/systems/pressurization/auto");
	if (manvs <= 1 and manvs >= 0 and !auto) {
		setprop("/systems/pressurization/outflowpos-man", manvs - 0.001);
	}
}


var update_CVR = func {
	CVR_master();
}

var CVR = maketimer(0.1, update_CVR);