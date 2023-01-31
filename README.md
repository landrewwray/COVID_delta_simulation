# COVID_delta_simulation

Inhomogeneous SIR model implemented in June, 2021 to anticipate the course of the COVID Delta wave.  New York City is treated as a collection of weakly connected and inhomogeneously susceptible subpopulations that each contain 10,000 people.  The model was inspired and guided by the inhomogeneity visible in citywide COVID data.

## Results

<img src="Susceptibility 2D histogram.png" width="800">

Results are summarized in 'Result summary.pdf'.  The program accurately anticipated key features of the COVID Delta wave in New York City, including:

1. A super-exponential onset, with a deceptively low initial exponential growth constant. This derives from the time it takes for the virus to find sensitive sub-populations, and is roughly analogous to the phenomenon of superdiffusion in biophysics.
2. Regional inhomogeneity in the vaccination rate yields a significantly higher total number of cases than would be expected based on the mean vaccination rate. 
3. When inhomogeneous groups are weakly coupled, one finds several features that have been noted in multiple waves of the COVID pandemic, including:
  • A longer, bumpy onset, containing preliminary epidemics that seed the disease into the broader population
  • A drawn-out recovery period, because weak inter-group coupling causes groups with R~1 to not fully ‘burn out’ with the primary outbreak.

## Running the software
Parameters are set at the top of 'runSIR.m', which is the only script that needs to be called.
