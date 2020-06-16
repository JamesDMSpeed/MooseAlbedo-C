# John Salisbury - Master's Project
This is the README for John Salisbury's master's project with NTNU.
<br/><br/>
## Project Title:
How do moose influence climate? The effect of moose browsing on surface albedo in successional boreal forest.
<br/><br/>
## Question 1:
### Does moose exclosure affect estimated surface albedo in Norwegian successional boreal forest?

**Summary**:
This component of the project is aimed at determining whether moose exclusion has an impact on surface albedo in Norwegian successional boreal forests. It uses two approaches to model the effects of exclosure on albedo - (1) the first approach involves using Norwegian NFI allometric models to calculate volume for trees in each SustHerb subplot, which is then combined with SWE + Temperature data in an albedo model; (2) the second approach involves using LiDAR data (from Ingrid Snøan's project) to calculate invidual tree-crown volume for all trees in a given LiDAR footprint, using that summed volume in an albedo model, and then using subplot species proportions to calculate a composite albedo value.

<br/><br/>
**File Structure:**
```
- 1_Albedo_Exclosures
  - Analysis (contains scripts and output for models and analysis)
  - Approach_1 (contains scripts and output for the first approach)
  - Approach_2 (contains scripts and output for the "LiDAR Hull" approach)
  - Approach_3 (contains scripts and output for the "LiDAR CHM" approach)
  - Data (contains all raw data necessary for both approaches)
  - Universal (contains scripts and output for variables relevant to both approaches - i.e. SWE, temp, etc.)
  - README.md
```

<br/><br/>
## Question 2:
### How does moose browsing affect surface albedo in Norwegian successional boreal forest on a regional scale?

**Summary**:
This component of the project seeks to examine the relationship between albedo and moose density in Norwegian successional boreal forests. It uses a forest data product from the NFI (SatSkog), spatial gridded climate data from SeNorge, and spatial herbivore density data from previous SustHerb work to model albedo as a function of moose density.

<br><br>
**File Structure:**
```
- 2_Albedo_Regional
  - Approach_1_SatSkog (contains scripts and output for the approach utilizing the SatSkog data product)
  - Data (contains all raw data)
  - README.md
```

<br/><br/>
## Other miscellaneous files
```
- 3_Albedo_Model (contains a function with the albedo model from Cherubini et al., which is used in all approaches)
- 4_Misc (contains other data and scripts that aren't directly relevant to the project)
```