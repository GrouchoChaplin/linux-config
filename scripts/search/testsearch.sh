#!/usr/bin/env bash


#find . \( -path './jsig*/Source/ExperimentalPlugins/PostProcesses/SensorEffects/WindowHeatingNode/testing/WindowHeatingNodeTests/*.cpp' -o -path './KEEP_FOR_NOW.2025_03_24_T14_58_09/jsig*/Source/ExperimentalPlugins/PostProcesses/SensorEffects/WindowHeatingNode/testing/WindowHeatingNodeTests/*.cpp' \) -type f -printf '%T+ %p\n' | sort -r 


find . \( -path './jsig*/Source/ExperimentalPlugins/PostProcesses/SensorEffects/WindowHeatingNode/testing/WindowHeatingNodeTests/*.cpp' -o -path './KEEP_FOR_NOW.2025_03_24_T14_58_09/jsig*/Source/ExperimentalPlugins/PostProcesses/SensorEffects/WindowHeatingNode/testing/WindowHeatingNodeTests/*.cpp' \) -type f | xargs stat --format 'DATE %Y :%y %n  * %s bytes' | sort -nr | cut -d: -f2- 
