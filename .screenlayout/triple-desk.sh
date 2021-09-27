#!/bin/sh
xrandr \
	--output DVI-I-0 \
	--mode 1280x1024 \
	--pos 3840x0 \
	--rotate normal \
	\
	--output DVI-I-1 \
	--off \
	\
	--output HDMI-0 \
	--primary \
	--mode 1920x1080 \
	--pos 0x138 \
	--rotate normal \
	\
	--output DP-0 \
	--mode 1920x1080 \
	--pos 1920x215 \
	--rotate normal \
	\
	--output DP-1 \
	--off \
	\
	--output DVI-D-0 \
	--off
