# geospatial
Geospatial Carpentries Workshop Play area

[Geospatial Data Carpentry Workshop,
UW-Madison,
June 5-8, 2023](https://uw-madison-datascience.github.io/2023-06-05-uwmadison-dc/) <https://go.wisc.edu/i4gsfr>

[Carpentries Etherpad](https://pad.carpentries.org/2023-06-05-uwmadison-dc)

- [Introduction to R for Geospatial Data](https://datacarpentry.org/r-intro-geospatial/)
- [Introduction to Geospatial Concepts](https://datacarpentry.org/organization-geospatial/)
- [Introduction to Geospatial Raster and Vector Data with R](https://uw-madison-datascience.github.io/r-raster-vector-geospatial/)

- [QGIS](https://qgis.org/en/site/)
  + [RPubs: R to QGIS workflow](https://rpubs.com/DUE-methods1/r-qgis)
  + [Spatial stratified sampling with RStudio and QGIS](https://bookdown.org/einavg7/sp_technical_guide/spatial-stratified-sampling-with-rstudio-and-qgis.html)
  + [RQGIS, Utilizing Rstudio as an alternative GIS](https://dges.carleton.ca/CUOSGwiki/index.php/RQGIS,_Utilizing_Rstudio_as_an_alternative_GIS)
  + [Processing lidar data using QGIS, LAStools and R](https://rstudio-pubs-static.s3.amazonaws.com/230154_30a0bbf22e2a49ecbfa1b72b2c7a8f96.html)
  + [ESCAP: Land cover change maps with QGIS & RStudio](https://www.unescap.org/resources/producing-land-cover-change-maps-and-statistics-step-step-guide-use-qgis-and-rstudio)
  + [Columbia U: GIS, Cartographic and Spatial Analysis Tools in R / Rstudio](https://guides.library.columbia.edu/geotools/R)

# Geospatial Raster Data

## Data and Packages

Key packages are

- [sf](https://cran.r-project.org/web/packages/sf/index.html)
- [terra](https://cran.r-project.org/web/packages/terra/index.html).

Previous packages `raster` and `rgdal` are now obsolete.

The data have been organized in The Carpentries nicely in FigShare as
[workshop data from carpentries site](https://ndownloader.figshare.com/files/23135981).
The data seem to come from NEON Raster Intro page
[NEON Raster 00: Intro to Raster Data in R](https://www.neonscience.org/resources/learning-hub/tutorials/dc-raster-data-r), via [Download Dataset](https://ndownloader.figshare.com/files/3701578).
The data are from two field sites:

- Harvard Forest (HARV)
- San Joaquin Experimental Range (SJER)

The key raster data are the following "geotif" files:

- HARV_dsmCrop.tif
- HARV_dsmCrop.tif
- HARV_DSMhill.tif
