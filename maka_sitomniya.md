# Maka Sitomniya Data Needs

This documents concerns the [ESIIL Working Group](https://esiil.org/working-groups) Maka Sitomniya that will be developing one or more sovereign enclaves (see [Sovereign Data Container](https://docs.google.com/presentation/d/1BtWngp1C28JHeSRx7v7Scp91InKcxygz6aAjOpVLGbk) slide deck). See also data sovereignty references and resources included in <https://byandell.github.io/pages/indigenous/>
and
[American Indian, Alaska Native, and Native Hawaiian Areas (AIANNH) ESIIL Code](https://github.com/byandell/geospatial/blob/main/Alaska.Rmd).

## Specific Sources

Bob Rabin and Robert Newman: Bob Rabin mentioned data products from NOAA/NESDIS that may be of interest in classifying Vegetation Health and Evaporative Stress Index (see links below). These products are estimated from NOAA Geostationary satellite observations and weather model data. They are available as 2-week averages (and longer) at spatial resolutions up to 4 km. Additional products may come from NLCD and other sources.

-   [NESDIS STAR](https://www.nesdis.noaa.gov/)
    -   [Drought Monitor](https://www.star.nesdis.noaa.gov/smcd/emb/droughtMon/products_droughtMon.php)
    -   [Vegetetation Health](https://www.star.nesdis.noaa.gov/smcd/emb/vci/VH/vh_browse.php) (Select Data type "Vegetation Health (VHI)" and Region "USA" )
    -   [Download Data](https://www.star.nesdis.noaa.gov/smcd/emb/vci/VH/vh_ftp.php)
-   [NOAA CLASS system](https://www.aev.class.noaa.gov/saa/products/welcome)
    -   Archive data for Vegetation Health
-   [NOAA Multi-Radar Multi-Sensor Quantitative Precipitation Estimation (MRMS QPE)](https://inside.nssl.noaa.gov/mrms/)
    -   Hourly and daily rainfall estimates on a 1-km grid over the entire U.S. from the network of National Weather Service radars and ground-based rain gauges. 
These estimates are from an operational product developed at the NOAA National Severe Storms Lab (NSSL) in Oklahoma. An archive of about 5 years (2020-2024) now exists and is available from amazonaws.com.
    -   [grib2 format files of 24-hour rainfall accumulation](https://noaa-mrms-pds.s3.amazonaws.com/index.html#CONUS/MultiSensor_QPE_24H_Pass2_00.00/)
    -   [Flooded Locations And Simulated Hydrographs Project (FLASH)](https://inside.nssl.noaa.gov/flash/)  Rainfall estimates input to hydrological model to estimate and predict streamflow
-   [National Land Cover Data (NLCD)](https://www.mrlc.gov/)
    -   Historical time series and change data (2001, 2004, 2006, 2008, 2011, 2013, 2016, 2019, and 2021)
    -   Drought index data (which may be in what Bob linked)
    -   Tree canopy cover (TCC) data from the same webpage.
-   [National Wetlands Inventory (NWI)](https://www.fws.gov/program/national-wetlands-inventory)
-   [State Wildlife Action Plans (SWAPs)](https://www.fishwildlife.org/afwa-informs/state-wildlife-action-plans)
    -   [South Dakota State Wildlife Action Plan](https://gfp.sd.gov/wildlife-action-plan/)
    -   [North Dakota State Wildlife Action Plan](https://gf.nd.gov/wildlife/swap)
    -   [Nebraska State Wildlife Action Plan](https://digitalcommons.unl.edu/nebgamepubs/131/)
- [Evaporative Stress Index (ESI)](https://www.star.nesdis.noaa.gov/smcd/emb/droughtMon/products_droughtMon.php)
    -   [Archive at 2-km resolution](ftp://ftp.star.nesdis.noaa.gov/pub/smcd/emb/lfang/GETD_STEMS)
    -   Online data archive dates back to 2022; FTP site is updated daily with real-time ESI. 
    -   Can request data back to 2003, with 2003-2017 at reduced resolution (8km).
    -   Currently, the files are in NetCDF format.
-   Additional items
    -   [Emergent Trends Complicate the Interpretation of the United States Drought Monitor (USDM)](https://doi.org/10.1029/2023AV001070)
    -   Are there animal / plant distribution data available for this region that includes ecologically-important or culturally important species / beings)?
    -   [Planet Labs](https://www.planet.com/) is useable at sub-regional extents: 3m satellite imagery that as 4-band and most recently 8? band. Good if there is need for high spatial and temporal resolution multispectral imagery for specific problems (monitoring specific sites, for example, on a monthly basis at high resolution). Because it is multispec we can get useful indices (NDVI is a classic, that only requires R and NR). I use it mostly for veg indices and habitat dynamics.
- 

Robin O'Malley: Possible data source is South Dakota Wildlife Action Plan. Much information, but not readily ingestible My guess is that we could obtain data coverages for species of interest/concern. The Heritage program focuses on rare/declining species, but the wildlife plan covers everything.

Robert Newman: Good suggestions Robin. I had thought of SWAPS too, but there are also concerns with SWAPS about what is included and what is not (I’ve been involved with the NDGF SWAP). But still, one of possibly multiple sources. I would add ND to the SD maps as relevant for the northern plains and within the 1851/1868 Treaty lands. And obviously within the Missouri River basin. I can talk to NDGF if we want species distributions maps that went into the [ND SWAP](https://gf.nd.gov/wildlife/swap)

For wetlands – I have found [National Wetlands Inventory (NWI)](https://www.fws.gov/program/national-wetlands-inventory) more accurate than NLCD, specifically for streams and small wetlands. NLCD 30m pixels miss a lot. We did an analysis comparing NLCD to NAIP imagery (0.6m) that we classified in-house and quantified the differences. Not published yet. Still, NLCD are good for coarser-grained data and much easier to work with for larger AOI. One of my questions is always, how much detail do we need, for different applications. NWI is publicly available and has broad geographic coverage, but only infrequent temporal updating.

Robin O'Malley: Agreed, and Nebraska might have useful info also, as it border Rosebud and yeah, NWI is better than NLCD -- 30 meters hides a lot.. And I think the question of "what do we want and WHY" is emerging.

## Specific Data Needs

Joni Tobacco: Needs if I were working in my Tribe’s Natural Resources Department or responding to a federal agency’s [NEPA](https://www.epa.gov/nepa) document. I think we need to look at it from a watershed perspective and organized in such a way. I would like to see the traditional Lakota names for each stream used, as well as Lakota terms for each data type (mni, inyan, maka, etc). Lower Brule Sioux Tribe published an excellent map with a lot of our (Lakota) place names for reference, with some minor corrections needed.

- [Lower Brule Sioux Tribe](https://www.lowerbrulesiouxtribe.com/)
- [Lower Brule Wildlife, Fish and Recreation](https://lowerbrulewildlife.com/)
  + [2024 Hunting Map](https://www.lowerbrulewildlife.com/image/cache/Lower_Brule_2024_Map_24.5x17.75_folded_to_4.4375_BGPRINT_2_.pdf)
  + [2023 Hunting Map](https://lowerbrulewildlife.com/image/cache/23Map_Complete_Final.pdf)
- [Geohydrology of Crow Creek and Lower Brule Indian Reservations, SD. Hydrologic Atlas 499. Lewis W. Howells](https://doi.org/10.3133/ha499)

So, it should start with all watersheds within the treaty territories. Sub-categories should be water, earth, air, wildlife, imagery, climate, a placeholder for cultural/sacred sites.

While we are doing this, we should keep in mind how to include or organize data used for specific purposes -- treaty rights, American Indian Religious Freedom Act, environmental and climate justice, environmental protection, etc. I am thinking data necessary for these purposes relate to:

-   habitat for culturally significant species (plants and animals),
-   threatened and endangered species,
-   hunting and fishing rights,
-   hazardous materials transportation,
-   infrastructure,
-   wildland fire management,
-   hydrologic,
-   atmospheric,
-   geologic
-   federal lands,
-   etc.

A data description for the relevance to a Tribal member end-user should be included. An example would be a short description of how to derive bison or deer habitat from available vegetation data, how to create a hydrologic budget for your reservation, fire severity index, air quality index, etc.

Robin O'Malley: Things we'll need data for:

-   watershed boundaries/DEM
-   wetlands
-   land cover (moderate \# of classes, e.g. NLCD)
-   stream and lake maps (i.e. hydrologic features)
-   residences, non-residential built-up (NLCD?)
-   range maps species of greatest conservation needs (SGCN, is a state designation)

## Pragmatic Aspects

We want resources making up this data cube that enable people of different technical skill levels to access data layers in intuitive ways. That is, where possible, existing tools for map overlays and visualizations should be made available.

In addition, we need ready access to how to quickly develop R and/or Python code to add layers for different types of data indicated above. Ideally, we use code minimally to stream useful data layers (appropriately filtered by bounding boxes, subsetting, etc.) into a cube. This should not be a coding exercise, but a pulling together of useful resources.

Not sure what the best platform (see Jim Sanovia's
[Sovereign Data Container](https://docs.google.com/presentation/d/1BtWngp1C28JHeSRx7v7Scp91InKcxygz6aAjOpVLGbk))
for this will be, or how we might use multiple platforms and tools. These might include:

- [ArcGIS Online](https://www.arcgis.com/sharing/rest/oauth2/signup?client_id=arcgisonline&response_type=token) (Tribal entities may have [ArcGIS Pro](https://www.esri.com/en-us/arcgis/products/arcgis-pro/overview) access)
- [QGIS](https://qgis.org/en/site/)
- [CoLab](https://colab.research.google.com/) (Python based_)
- <https://sdn.ramadda.org>
- R Shiny apps
- Jupyter notebooks
- other tools from EarthLab, etc.?

