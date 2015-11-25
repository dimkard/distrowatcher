#!/bin/bash
rm distrowatcher.plasmoid
plasmapkg2 --remove org.kde.distrowatcher
./kNewHostStuff.sh
plasmapkg2 --install distrowatcher.plasmoid 
plasmawindowed org.kde.distrowatcher