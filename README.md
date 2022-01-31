# dreMR_sims

The code included in this repository is used for performing dreMR image simulations outlined in McCready MA, Handler WB, Chronik BA, An improved homogeneity design method for fast field-cycling coils in molecular MRI. Magnetic Resonance in Medicine. doi:10.1002/mrm.29178. This repository does not include the larger library for simulation of coil designs and their resulting fields.

Sample.m
Class for developing simulation framework. Defines the simulation domain.

Pulse.m
Class for developing simulation framework. Defines the dreMR pulse parameters (all pulses in this work were square)

BlochDremr.m
Class for developing simulation framework. Takes a given Sample and Pulse and calculates the longitudinal magnetization across the domain following the dreMR pulse. Assumes Mz is zeroed immediately before the pulse. If given a coil design as input it will apply its field map over the domain using a numerical Biot-Savart calculator.

MRM_designsim.m
Script utilizing simulation. Script producing Figure 5 of the manuscript using the new and old dreMR insert designs. Attempting to run will throw an error without the library for representing coil designs and was provided for a readable example of how the simulation is called with coil designs.

MRM_runnable.m
Script utilizing simulation. Runnable version of designsim script. This uses no coil designs and generates some fake but realistic relaxivity data for the user (similar to values for VivoTrax used in manuscript).
