# John Salisbury - Master's Project
This is the README for John Salisbury's master's project with NTNU.
<br/><br/>
## Tentative Project Title:
How do moose influence climate? The effect of moose browsing on surface albedo in successional boreal forest.
<br/><br/>
## Project Components:
This section briefly describes relevant info for each of the main research questions (or components) of this project.
<br/><br/>
### Question 1: Does moose exclosure affect estimated surface albedo in Norwegian successional boreal forest?
<br/><br/>
**Hypothesis**:
> Moose exclosure will increase estimated surface albedo in successional boreal forest, due to greater presence of reflective deciduous trees and less canopy-masking of snow during winter months.

<br><br>
**Summary**:
This component of the project is aimed at determining whether moose browsing has an impact on surface albedo in Norwegian successional boreal forests. The component process will look something like the following:

<br><br>
**1. Assemble Data for Albedo Models:**
  - *_Existing LiDAR data_*:
    - Remove large trees from LiDAR data
    - Calculate forest stand volume (FSV)
  - *_Temperature (T) data_*:
    - Pull spatial historical T data for each plot (source TBD) - date of T data should correspond to the year of the LiDAR data for the relevant plot
    - Average T data into monthly temporal resolution (which is required for the albedo model)
  - *_Snow-water equivalent (SWE) data_*:
    - Pull historical SWE data for each plot (source TBD) - date of SWE data should correspond to the year of the LiDAR data for the relevant plot
  - *_Species composition (spruce, pine, deciduous)_*:
    - Get %'s for each plot (based on historical SUSTHERB data) - year of observations should correspond to the year of the LiDAR data for the relevant plot

**2. Calculate Albedo Values for Each Plot:**
  - *_Create R version of model:_*
    - Model currently lives in a spreadsheet - would be more useful to re-construct it in R
  - *_Volume-Based Albedo Model_*:
    - Plug FSV, T monthly averages (12x for 1 year), and SWE monthly averages (12x for 1 year) into model to get *_monthly albedo estimates_* for each forest type and each plot (12x total estimates, 3x sets of estimates, 48x total)
    - Based on species composition %'s, break monthly albedo values into components by multiplying them with relevant species composition % (ex. estimated albedo value of 0.7 for pine forests; plot is 95% pine forest; multiply 0.7 * 0.95 to get a component albedo estimate for pine in that plot)
 
    
**2. Compare albedo between exclosures and open plots:**
  - *_Mixed Effects Model_*:
    - ```A = E + M + R + D + S + T + Error```
    - A -> albedo (numeric value, 0-1)
    - E -> Exclosure Treatment (open or exclosure)
    - M -> Moose density (kg/km-2)
    - R -> Roe deer density (kg/km-2)
    - D -> Red deer density (kg/km-2)
    - S -> Random effect for study site
    - T -> Random effect for time (since we will have 12 monthly albedo estimates for each plot)
   
**3. Reject or fail to reject hypothesis:**
  - Does moose exclosure significantly affect surface albedo in Norwegian successional boreal forest?

<br/><br/>
**File Structure:**
```
- 1_Albedo_Exclosures
  - 1_Data (contains subfolders with all data necessary for albedo models)
  - 2_Model_FSV (contains code for albedo model - 'Forest Stand Volume' version)
  - 3_Model_Age (contains code for albedo model - 'Forest Stand Age' version)
  - 4_Analysis (contains code for statistical analysis of albedo results)
  - README.md
```
<br/><br/>
### Question 2: What is the impact of moose exclosure on long-term predictions of radiative forcing in Norwegian successional boreal forest?

**Summary**:
This component of the project is aimed at determining whether moose browsing has an impact on long-term predictions (10-100 years) of radiative forcing in Norwegian successional boreal forests. The component process will look something like the following:
<br/><br/>

**Hypothesis**:
> Moose exclosure will decrease long-term predictions of radiative forcing in successional boreal forest, due to predicted increases in albedo and greater deciduous biomass (i.e. carbon storage).

<br/><br/>
**File Structure:**
```
- 1_RF_Exclosures
  - 1_Data (contains subfolders with all data necessary for radiative forcing (RF) models)
  - 2_Model (contains code for RF predictive model)
  - README.md
```

<br/><br/>
### Question 3: What is the regional impact of moose browsing on surface albedo in Norwegian successional boreal forest?

**Hypothesis**:
> Need to develop a hypothesis here.

<br/><br/>
### Bonus (if time): R Shiny spatial visualization of regional albedo model

**Summary**:
> I'd like to effectively communicate my results in an interactive, web-based manner. To do this, I'd like to create an R Shiny app with an interactive spatial visualization of the regional albedo model. I'm thinking that I'll do the following:
<br><br>
1. Create an R Shiny spatial visualization, using the spatial data from the model (overlaid on a vector map of Norway)
  - Create a slider where the user can vary moose browsing density -> the spatial data should update in the visualization, and the map should update (however, this may not be realistic if the regional model takes significant time to run! In that case, we'll go with the Mapbox option below).

