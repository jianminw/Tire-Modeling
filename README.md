# Tire-Modeling
Tire test data has been removed because this is a public repository. 

# Files
## Main.m
This file loads up data and runs Slip_Angle_Modeling.m and Slip_Ratio_Modeling.m

## Slip_Angle_Modeling.m
Goes through all the slip angle sweeps and finds the corresponding Pacejka coefficients. Results are stored in SA_Pacejka_Coeff.mat. 

## Slip_Ratio_Modeling.m
Goes through all the slip ratio sweeps and finds the corresponding Pacejka coefficients. Results are stored in SR_Pacejka_Coeff.mat.

## Pacejka.m
This file takes in data (input and output) and returns coefficients for a Pacejka function using a least square fit. 

## Pacejka_Interpolation.m
Legacy file. Contains a function to retrieve interpolated pacejka coefficients.  

## SADataViewer.m
A script to quickly graph data found in runs 20 and 21. Primarily data that concerns slip ratio testing. 

## SRDataViewer.m
A script to quickly graph data found in runs 39 and 40. Primarily data that concerns slip angle testing. 

## SA_Coeff_Data.m
A class to store values for Pacejka coefficients for undriven tests and the corresponding conditions (pressure, camber, normal force)

## SR_Coeff_Data.m
A class to store values for Pacejka coefficients for driven tests and the corresponding conditions (pressure, camber, normal force, slip angle)

## SA_Pacejka_Coeff.mat
Data file for use in steady state simulations.

## SR_Pacejka_Coeff.mat
Data file for use in steady state simulations. 

## SA_Interpolation.m
Legacy file. Contains old interpolation method. 

## SR_Interpolation.m
Legacy file. Contains old interpolation method. 

## Tire_Modeling.m
Legacy file. Contains an interface to view interpolated Pacejka functions using the old method. 

## Tire_Hash.m
Legacy file. Contains a support function for the old interpolation method. 

## combine.m
A function to combine two structs together, when the two structs have fields of the same name. 

## degtorad.m
Converts degrees to radians.

## timeSplice.m
Not sure how this is different from combine, but both are used to put the different runs together to be processed. 

## odeCar.m
Reference. 

## segment.m
A function that detects cutoffs between different sweeps.
