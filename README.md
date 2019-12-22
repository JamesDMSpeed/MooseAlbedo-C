# John Salisbury - Master's Project
This is the README for John Salisbury's master's project with NTNU.
<br/><br/>
## Tentative Project Title:
How do moose influence climate? The effect of moose browsing on albedo and radiative forcing in successional boreal forest.
<br/><br/><br/>
## Project Components:
This section briefly describes relevant info for each of the main research questions (or components) of this project.
<br/><br/>
### Question 1: What is the impact of moose exclosure on surface albedo in Norwegian successional boreal forest?

**Summary**:
This component of the project is aimed at determining whether moose browsing has an impact on surface albedo in Norwegian successional boreal forests. The component process will look something like the following:
<br/><br/>
**1. Calculate albedo for each plot, using FSV albedo model:**
  - Use existing LiDAR data -> forest stand volume (FSV)
  - Temperature data - (TBD)
  - Snow-water equivalent (SWE) data - (TBD)
  - % of plot covered by species (spruce, pine, etc - exclude old trees?)
    -  FSV + Temp + SWE -> FSV albedo model -> estimated albedo value (0-1) for each species, by month
    - Muliply estimated monthly albedo value for a given species by % of that species in plot (repeat for each species and each month) -> * *Composite estimated albedo value for entire plot, by month* *
    
**2. Compare albedo between exclosures and open plots:**
  - * *Need to further develop/research methods here* *
  
**3. Reject or fail to reject hypothesis**

<br/><br/>
**Hypothesis**:
> Moose exclosure will increase surface albedo in successional boreal forest, due to greater presence of reflective deciduous trees and less canopy-masking of snow during winter months.

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

