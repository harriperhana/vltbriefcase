#!/bin/bash

# Compile script
cd tf/addons/sourcemod/scripting && ./spcomp vltbriefcase.sp

# And move it into plugins directory
mv vltbriefcase.smx ../plugins/