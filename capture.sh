#!/bin/bash
################################
#StreamThru.pl
#Copyright Brandon Lucia 2010
#
#This script does very little except to appropriately format the audio
#data that rec outputs so that it will play well with streamthru.pl.
#
#To use streamthru, pipe the output of this script to streamthru.pl
#
############################
rec -2 -c2 -s -r44100 -traw - | lame -r -s44.1 --bitwidth=16 --signed - -
