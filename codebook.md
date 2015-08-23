Human Activity Recognition Using Smartphones Tidy Data Set Code Book
=====================================================
### This Code Book describes the data after Merging, Cleaning and Transforming it into a tidy data set
#### Date: 08/23/2015
#### Code book prepared by Akhil Vangala as part of course project for Getting and Cleaning Data in R(DataScience Specializartion)
#### DataSourc: UCI Machine learning Repository
Note: please run run_analysis.R script in R environment to Extract and clean the data set.
If you have any questions about the code book please contact at akhil.vangala at yahoo.com

Dataset is goruped by 10 qualitative variables for one avg sensor value (quantitative)

|Variable               | VariableType 	|Comments                                                                                                           	|
|---------------------	|---------------	|--------------------------------------------------------------------------------------------------------------------	|
| Subject             	|   Numeric      	| Unique Identifier of  human volunteer in the dataset                                                                       	|
| Acitivity           	|   Character   	| Activity performed by the volunteer during the experments                                                          	|
| Domain              	|   Character   	| Time domain signal or Frequency domain signal                                                                      	|
| Acceleration Signal 	|   Character   	| Describes if it is a Body or Gravity Acceleration signal                                                           	|
| Sensor              	|   Character   	| Sensor used to measure signal. Accelerometer or Gyroscope                                                          	|
| JerkSignal          	|   Boolean     	| Jerk is the rate of change in acceleration over time of an object. Is Jerk calculated for the signal TRUE or FALSE 	|
| Axis                	|   Character   	| Plane of axis for signal "X","Y" Or "Z". if its a three dimension plane "XYZ"                                      	|
| MagnitudeSignal     	|   Boolean     	| Is Magnitude calculated for the signal.TRUE or FALSE                                                               	|
| Measure             	|   Character   	| Mathematical function used to calculate the value                                                                  	|
| AvgSensorValue        |   Numeric       | Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.Triaxial Angular velocity from the gyroscope with time and frequency domain variables
