# A3XX mCDU by Joshua Davidson (it0uchpods) and Jonathan Redpath

#######################################
# Copyright (c) A3XX Development Team #
#######################################

var perfCRZInput = func(key) {
	if (key == "L6") {
		setprop("/MCDU[1]/page", "CLB");
	}
	if (key == "R6") {
		setprop("/MCDU[1]/page", "DES");
	}
}