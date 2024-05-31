# geospatial

Yandell's Geospatial Workshops Play Area

This is now a library. Note that all needed packages are listed as Depends _except_ `basemapR`. You can install as follows without cloning the library:

```
devtools::install_github('Chrisjb/basemapR')
devtools::install_github('byandell/geospatial')
```

There is a draft shiny app for the `redline` example at this point, which will mature. Try

```
library(geospatial)
redlineApp()
```

See slide deck for 
[ESIIL Geospatial R Package](https://docs.google.com/presentation/d/1--FSPJZF6ZJeItBrasQxukgs6AN-YxHBA78tNlOGYv4).

## Geospatial Resources

### Books and Online Docs

- [Data Carpentry Workshop](https://datacarpentry.org/geospatial-workshop/)
  + [Introduction to R for Geospatial Data](https://datacarpentry.org/r-intro-geospatial/)
  + [Introduction to Geospatial Concepts](https://datacarpentry.org/organization-geospatial/)
  + [Introduction to Geospatial Raster and Vector Data with R](https://uw-madison-datascience.github.io/r-raster-vector-geospatial/)
- [Spatial Data Science book by Edzer Pebesma and Roger Bivand](https://r-spatial.org/book/)
- [Geospatial Vector Data in R with SF (Coding Club)](https://ourcodingclub.github.io/tutorials/spatial-vector-sf/)
- Online Comparisons of Some Spatial Packages
  + [Comparison of terra and stars packages by Chris Brown](https://www.seascapemodels.org/rstats/2021/06/01/STARS.html)
  + [Marius Appel - Creating and Analyzing Multi-Variable Earth Observation Data Cubes in R (part 1)](https://www.youtube.com/watch?v=kE-se6zg6HE) (2 hours)
  + [Stack Overflow: stack geotiff with stars 'along' when 'band' dimension contains band + time information](https://stackoverflow.com/questions/75249639/stack-geotiff-with-stars-along-when-band-dimension-contains-band-time-info)

- [ArcGIS Online](https://www.arcgis.com/sharing/rest/oauth2/signup?client_id=arcgisonline&response_type=token)
  + Free online accounts, with new features added over time
- [QGIS](https://qgis.org/en/site/)
  + [RPubs: R to QGIS workflow](https://rpubs.com/DUE-methods1/r-qgis)
  + [Spatial stratified sampling with RStudio and QGIS](https://bookdown.org/einavg7/sp_technical_guide/spatial-stratified-sampling-with-rstudio-and-qgis.html)
  + [RQGIS, Utilizing Rstudio as an alternative GIS](https://dges.carleton.ca/CUOSGwiki/index.php/RQGIS,_Utilizing_Rstudio_as_an_alternative_GIS)
  + [Processing lidar data using QGIS, LAStools and R](https://rstudio-pubs-static.s3.amazonaws.com/230154_30a0bbf22e2a49ecbfa1b72b2c7a8f96.html)
  + [ESCAP: Land cover change maps with QGIS & RStudio](https://www.unescap.org/resources/producing-land-cover-change-maps-and-statistics-step-step-guide-use-qgis-and-rstudio)
  + [Columbia U: GIS, Cartographic and Spatial Analysis Tools in R / Rstudio](https://guides.library.columbia.edu/geotools/R)


### R Packages

Packages to Create Data Cube Layers

- [gdalcubes](https://cran.r-project.org/package=gdalcubes)
  + <https://github.com/appelmar/gdalcubes>
  + [1. Creating data cubes from local MODIS imagery by Marius Appel](https://cran.r-project.org/web/packages/gdalcubes/vignettes/gc01_MODIS.html)
- <https://r-spatial.org/>
  + [sf](https://cran.r-project.org/package=sf) (<https://github.com/r-spatial/sf>)
  + [stars](https://cran.r-project.org/package=stars)<https://github.com/r-spatial/stars>
- <https://rspatial.org/>
  + [terra](https://cran.r-project.org/package=terra) (<https://github.com/rspatial/terra>)
  + [sf](https://cran.r-project.org/package=sf) (<https://github.com/rspatial/raster>)
- [tidyterra](https://cran.r-project.org/package=tidyterra)
  + <https://dieghernan.github.io/tidyterra/>
  + Extension of the 'tidyverse' for 'SpatRaster' and 'SpatVector' objects of the 'terra' package

Packages to Access Data

- [rstac](https://cran.r-project.org/package=rstac): Access, search and download from SpatioTemporal Asset Catalog (STAC)
- [osmdata](https://cran.r-project.org/package=osmdata): Download and import of 'OpenStreetMap' ('OSM') data
  + <https://www.openstreetmap.org/>
  + [Open Street Map Data](https://rspatialdata.github.io/osm.html)
  + [Retrieving Open Street Map data using the osmdata package](https://rspatialdata.github.io/osm.html#Retrieving_Open_Street_Map_data_using_the_osmdata_package)
  + [Database of Open Street Map Names](https://github.com/OSMNames/OSMNames)
  + <https://osmnames.org/>
- [geos](https://cran.r-project.org/package=geos): R API to the Open Source Geometry Engine ('GEOS')
- [landsat](https://cran.r-project.org/package=landsat): Processing of Landsat and other multispectral satellite imagery

Previous package `rgdal` is now obsolete. Unsure about status of `raster` package.

## Data Repositories

- <https://data-library.esiil.org>
  + [American Indian and Alaska Native Areas](https://data-library.esiil.org/indian_country/aiannh/AIANNH/)
- See list on menu of
<https://cu-esiil.github.io/hackathon2023_datacube/code_for_building_cube/Pull_flood_data/>

These have been compiled in [datasets.csv](https://github.com/byandell/geospatial/blob/main/datasets.csv).

Data are stored in different coordinating systems, which makes it important
to transform between them. Some common ones:

- [EPSG:4326](https://epsg.io/4326): WGS84 = World Geodetic System 1984
- [EPSG:32618](https://epsg.io/32618): WGS84 for UTM zone 18N (North America)
- [EPSG:32730](https://epsg.io/32720): WGS84 for UTM zone 20S (South America)

## Geospatial Workshops

### [ESIIL Hackathon, CU Boulder, November 15-17, 2023](https://cu-esiil.github.io/hackathon2023_datacube/)

[ESIIL_Art_Data_Cube.Rmd](https://github.com/byandell/geospatial/blob/main/ESIIL_Art_Data_Cube.Rmd): Yandell edit of Ty Tuff's The Art of Making a Datacube

### [Geospatial Data Carpentry Workshop, UW-Madison, June 5-8, 2023](https://uw-madison-datascience.github.io/2023-06-05-uwmadison-dc/) <https://go.wisc.edu/i4gsfr>

[Carpentries Etherpad](https://pad.carpentries.org/2023-06-05-uwmadison-dc)

[Geospatial.Rmd](https://github.com/byandell/geospatial/blob/main/Geospatial.Rmd): Rmarkdown from Workshop

#### Geospatial Download for Data Carpentry Workshop

The data have been organized in The Carpentries nicely in FigShare as
[workshop data from carpentries site](https://ndownloader.figshare.com/files/23135981).
See also the <https://datacarpentry.org/geospatial-workshop/> page section on Data and more information at <https://datacarpentry.org/geospatial-workshop/data.html>.
The data seem to come from NEON Raster Intro page
[NEON Raster 00: Intro to Raster Data in R](https://www.neonscience.org/resources/learning-hub/tutorials/dc-raster-data-r), via [Download Dataset](https://ndownloader.figshare.com/files/3701578).
The data are from two field sites:

- Harvard Forest (HARV)
- San Joaquin Experimental Range (SJER)

The key raster data are the following "geotif" files:

- HARV_dsmCrop.tif
- HARV_dsmCrop.tif
- HARV_DSMhill.tif

It should be possible using some of the commands in the [The art of making a data cube](https://cu-esiil.github.io/hackathon2023_datacube/code_for_building_cube/stac_mount_save/) to elegantly download needed data on the fly.
