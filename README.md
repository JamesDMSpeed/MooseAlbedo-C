# John Salisbury - Master's Project
This is the README for John Salisbury's master's project with NTNU.
<br/><br/>
## Project Title:
How do moose influence climate? The effect of moose browsing on surface albedo in successional Norwegian boreal forest.
<br/><br/>
## Question 1:
### Does moose exclosure affect estimated surface albedo in successional Norwegian boreal forest?

**Summary**:
This component of the project is aimed at determining whether moose exclusion has an impact on surface albedo in Norwegian successional boreal forests. It uses ~~four approaches~~ one approach to examine the effects of moose exclosure on albedo:
1. The **first approach** involves using SustHerb allometric biomass models to estimate volume for trees in each SustHerb subplot, which is then summed and combined with SWE + Temperature data in an albedo model
2. ~~The **second approach** involves using LiDAR data (from Ingrid Snøan's master's project) to calculate invidual tree-crown volume for all trees in a given LiDAR footprint, using that summed volume in an albedo model, and then using subplot species proportions to calculate a composite albedo value.~~
3. ~~The **third approach** involves using the same approach as #2, except that plot volume is obtained by summing the volumes of all pixels produced by the plot canopy height model~~
4. ~~The **fourth approach** uses an 'age-based' variant of the albedo model (which accepts stand age instead of plot volume as a parameter). Tree species proportions are then used to calculate composite albedo values, as in Approaches 2 & 3.~~

~~This component of the project also includes a **longitudinal** analysis of albedo in moose exclosures and open plots. It uses the albedo model developed by Hu et al., but will be focused on how moose exclosure affects albedo across successional stages (i.e. years since clearcut):~~
1. ~~**Age-based analysis** - this component of the longitudinal analysis uses the 'age-based' variant of the albedo model to calculate monthly albedo for each plot across all years since clearcut~~
2. ~~**Volume-based analysis** - this component of the analysis uses the 'volume-based' variant of the albedo model in tandem with the methods used in 'Approach 1' to calculate albedo across all years since clearcut.~~

<br/><br/>
**File Structure:**
```
- 1_Albedo_Exclosures
  - Analysis (contains scripts and output for models and analysis)
  - Approach_1 (contains scripts and output for the first approach)
  - Approach_2 (OLD! // contains scripts and output for the "LiDAR Hull" approach)
  - Approach_3 (OLD! // contains scripts and output for the "LiDAR CHM" approach)
  - Approach_4 (OLD! // contains scripts and output for the "Stand Age" approach)
  - Approach_Longitudinal (OLD! // contains scripts and output for longitudinal analysis of albedo)
  - Comparisons (OLD! // contains scripts and output for comparisons of different approaches)
  - Data (contains all raw data necessary for all approaches)
  - Reports (contains all R markdown reports for each approach)
  - Universal (contains scripts and output for variables relevant to both approaches - i.e. SWE, temp, etc.)
```

<br/><br/>
**Markdown Reports:**
These interactive R Markdown reports are dynamically generated from the scripts + output for each approach. 

* **Approach 1**:
  * [~~Initial Report~~](https://allyworks.io/moose-albedo/exclosures/approach1/final_report_approach_1.html)
  * [Updated Report](https://allyworks.io/moose-albedo/exclosures/approach1/updated_report_approach_1.html)

* ~~**Approach 2**:~~
  * [~~Initial Report~~](https://allyworks.io/moose-albedo/exclosures/approach2/final_report_approach_2.html)

* ~~**Approach 3**:~~
  * [~~Initial Report~~](https://allyworks.io/moose-albedo/exclosures/approach3/final_report_approach_3.html)

* ~~**Approach 4**:~~
  * [~~Initial Report~~](https://allyworks.io/moose-albedo/exclosures/approach4/final_report_approach_4.html)

~~Additionally, below are reports for the 'longitudinal' approach:~~

* ~~**Longitudinal Approach**:~~
  * ~~Age-based albedo model:~~
      * [~~Initial Report~~](https://allyworks.io/moose-albedo/exclosures/longitudinal/age/final_report_longitudinal_age.html)

~~And finally, here are reports for comparisons between the approaches:~~

* ~~**Comparisons (Appr. 1-4):**~~
  * [~~Initial Report~~](https://allyworks.io/moose-albedo/exclosures/comparisons/final_report_comparisons.html)
 

<br/><br/>
## Question 2:
### How does moose density affect surface albedo in successional Norwegian boreal forests on a regional scale?

**Summary**:
This component of the project seeks to examine the relationship between albedo and moose density in Norwegian successional boreal forests. It uses a forest data product from NIBIO (SatSkog), spatial gridded climate data from SeNorge, and spatial herbivore density data from previous SustHerb work to model albedo as a function of moose density.

<br><br>
**File Structure:**
```
- 2_Albedo_Regional
  - Approach_1_SatSkog (contains scripts and output for the approach utilizing the SatSkog data product)
  - Data (contains all raw data and SatSkog shapefiles files, EXCLUDING seNorge netCDF files, which are stored externally)
  - Reports (contains relevant R Markdown reports)
```

<br/><br/>
**Markdown Reports:**
These interactive R Markdown reports are dynamically generated from the scripts + output for each approach. 

* SatSkog Approach:
  * [~~Initial Report~~](https://allyworks.io/moose-albedo/regional/final_report_regional.html)
  * [Clustering Attempt #1](https://allyworks.io/moose-albedo/regional/regional_clustering_1.html)
  
<br/><br/>
## Other miscellaneous files
```
- 3_Albedo_Model (contains the albedo models developed by Hu et al.)
- 4_Misc (contains other data and scripts that aren't directly relevant to the project)
```