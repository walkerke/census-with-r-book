# Other Census and government data resources



Most of the examples covered in the book to this point use data from recent US Census Bureau datasets such as the Decennial Census since 2000 and the American Community Survey. These datasets are available through the US Census Bureau's APIs and in turn accessible with **tidycensus** and related tools. However, analysts and historians may be interested in accessing data from much earlier - perhaps all the way back to 1790, the first US Census! Fortunately, these historical datasets are available to analysts through the [National Historical Geographic Information System (NHGIS) project](https://www.nhgis.org/) and the [Minnesota Population Center's](https://pop.umn.edu/) [IPUMS project](https://ipums.org/). While both of these data repositories have typically attracted researchers using commercial software such as ArcGIS (for NHGIS) and Stata/SAS (for IPUMS), the Minnesota Population Center has developed an associated **ipumsr** R package to help analysts integrate these datasets into R-based workflows.

Additionally, the US Census Bureau publishes many other surveys and datasets besides the decennial US Census and American Community Survey. While **tidycensus** focuses on these core datasets, other R packages provide support for the wide range of datasets available from the Census Bureau and other government agencies.

The first part of this chapter provides an overview of how to access and use historical US Census datasets in R with NHGIS, IPUMS, and the **ipumsr** package. Due to the size of the datasets involved, these datasets are not provided with the sample data available in the book's data repository. To reproduce, readers should follow the steps provided to sign up for an IPUMS account and download the data themselves. The second part of this chapter covers R workflows for Census data resources outside the decennial US Census and American Community Survey. It highlights packages such as **censusapi**, which allows for programmatic access to all US Census Bureau APIs, and **lehdr**, which grants access to the LEHD LODES dataset for analyzing commuting flows and jobs distributions. Other government data resources are also addressed at the end of the chapter.

## Mapping historical geographies of New York City with NHGIS

The National Historical Geographic Information System (NHGIS) project [@manson2021] is a tremendous resource for both contemporary and historical US Census data. While some datasets (e.g. the 2000 and 2010 decennial US Censuses, the ACS) can be accessed with both **tidycensus** and NHGIS, NHGIS is an excellent option for users who prefer browsing data menus to request data and/or who require historical information earlier than 2000. The example in this section will illustrate an applied workflow using NHGIS and its companion R package, **ipumsr** [@ellis_and_burk2020] to map geographies of immigration in New York City from the 1910 Census.

### Getting started with NHGIS

To get started with NHGIS, visit [the NHGIS website](https://www.nhgis.org/) and click the "REGISTER" link at the top of the screen to register for an account. NHGIS asks for some basic information about your work and how you plan to use the data, and you'll agree to the NHGIS usage license agreement. Once registered, return to the NHGIS home page and click the "Get Data" button to visit the NHGIS data browser interface.

<div class="figure">
<img src="img/screenshots/nhgis-1.png" alt="NHGIS data browser interface" width="100%" />
<p class="caption">(\#fig:nhgis-img-1)NHGIS data browser interface</p>
</div>

A series of options on the left-hand side of your screen. These options include:

-   **Geographic levels**: the level of aggregation for your data. NHGIS includes a series of filters to help you choose the correct level of aggregation; click the plus sign to select it. Keep in mind that not all geographic levels will be available for all variables and all years. To reproduce the example in this section, click "CENSUS TRACT" then "SUBMIT."

-   **Years**: The year(s) for which you would like to request data. Decennial, non-decennial, and 5-year ranges are available for Census tracts. Note that many years are greyed out - this means that no data are available for those years at the Census tract level. The earliest year for which Census tract-level data are available is 1910, which is the year we will choose; check the box next to "1910" then click SUBMIT.

-   **Topics**: This menu helps you filter down to specific areas of interest in which you are searching for data to select. Data are organized into categories (e.g. race, ethnicity, and origins) and sub-topics (e.g. age, sex). Topics not available at your chosen geography/year combination are greyed out. Choose the "Nativity and Place of Birth" topic then click SUBMIT.

-   **Datasets**: The specific datasets from which you would like to request data, which is particularly useful when there are multiple datasets available in a given year. In this applied example, there is only one dataset that aligns with our choices: Population Data for Census tracts in New York City in 1910. As such, there is no need to select anything here.

The **Select Data** menu shows which Census tables are available given your filter selections. Usefully, the menu includes embedded links that give additional information about the available data choices, along with a "popularity" bar graph showing the most-downloaded tables for that particular dataset.

<div class="figure">
<img src="img/screenshots/nhgis-select-data.png" alt="NHGIS Select Data screen" width="100%" />
<p class="caption">(\#fig:nhgis-select-data)NHGIS Select Data screen</p>
</div>

For this example, choose the tables "NT26: Ancestry" and "NT45: Race/Ethnicity" by clicking the green plus signs next to the two to select them. Then, click the **GIS FILES** tab. This tab allows you to select companion shapefiles that can be merged to the demographic extracts for mapping in a desktop GIS or in software like R. Choose either of the Census Tract options then click "CONTINUE" to review your selection. On the "REVIEW AND SUBMIT" screen, keep the "Comma delimited" file structure selected and give your extract a description if you would like.

When finished, click SUBMIT. You'll be taken to the "EXTRACTS HISTORY" screen where you can download your data when it is ready; you'll receive a notification by email when your data can be downloaded. Once you receive this notification, return to NHGIS and download both the table data and the GIS data to the same directory on your computer.

### Working with NHGIS data in R

Once acquired, NHGIS spatial and attribute data can be integrated seamlessly into R-based data analysis workflows thanks to the **ipumsr** package. **ipumsr** includes a series of NHGIS-specific functions: `read_nhgis()`, which reads in the tabular aggregate data; `read_nhgis_sf()`, which reads in the spatial data as a simple features object; and `read_nhgis_sp()`, which reads in the spatial data in legacy sp format.

`read_nhgis_sf()` has built-in features to make working with spatial and demographic data simpler for R users. If the `data_file` argument is pointed to the CSV file with the demographic data, and the `shape_file` argument is pointed to the shapefile, `read_nhgis_sf()` will read in both files simultaneously and join them correctly based on a common `GISJOIN` column found in both files. An additional perk is that `read_nhgis_sf()` can handle the zipped folders, removing an additional step from the analyst's data preparation workflow.

The example below uses `read_nhgis_sf()` to read in spatial and demographic data on immigrants in New York City in 1910. As the 1910 shapefile folder includes both NYC Census tracts and a separate dataset with US counties, the top-level folder should be unzipped, `shape_file` pointed to the second-level zipped folder, and the `shape_layer` argument used to exclusively read in the tracts. The `filter()` call will drop Census tracts that do not have corresponding data (so, outside NYC).


```r
library(ipumsr)
library(tidyverse)

nyc_1910 <- read_nhgis_sf(
  data_file = "data/NHGIS/nhgis0099_csv.zip",
  shape_file = "data/NHGIS/nhgis0099_shape/nhgis0099_shapefile_tl2000_us_tract_1910.zip",
  shape_layer = starts_with("US_tract_1910")
) %>%
  filter(!is.na(TRACTA))
```

```
## Use of data from NHGIS is subject to conditions including that users should
## cite the data appropriately. Use command `ipums_conditions()` for more details.
## 
## 
## Reading data file...
## Reading geography...
## options:        ENCODING=latin1 
## Reading layer `US_tract_1910' from data source 
##   `/tmp/Rtmp1N3nBP/filed295384c24c/US_tract_1910.shp' using driver `ESRI Shapefile'
## Simple feature collection with 1989 features and 6 fields
## Geometry type: MULTIPOLYGON
## Dimension:     XY
## Bounding box:  xmin: 489737.4 ymin: 130629.6 xmax: 2029575 ymax: 816129.7
## Projected CRS: USA_Contiguous_Albers_Equal_Area_Conic
```

`read_nhgis_sf()` has read in the tracts shapefile as a simple features object then joined the corresponding CSV file to it *and* imported data labels from the data codebook. Note that if you are reproducing this example with data downloaded yourself, you will have a unique zipped folder & file name based on your unique download ID. The "99" in the example above reflects the 99th extract from NHGIS for a given user, not a unique dataset name.

The best way to review the variables and their labels is the `View()` command in RStudio, which is most efficient on sf objects when the geometry is first dropped with `sf::st_drop_geometry()`.


```r
View(sf::st_drop_geometry(nyc_1910))
```

<div class="figure">
<img src="img/screenshots/nhgis-data-view.png" alt="NHGIS data in the RStudio Viewer" width="100%" />
<p class="caption">(\#fig:nhgis-data-view)NHGIS data in the RStudio Viewer</p>
</div>

As shown in the graphic above, the variable labels are particularly useful when using `View()` to understand what the different variables mean without having to reference the codebook.

### Mapping NHGIS data in R

The message displayed when reading in the NHGIS shapefile above indicates that the Census tract data are in a projected coordinate reference system, `USA_Contiguous_Albers_Equal_Area_Conic`. The spatial data can be displayed with `plot()`:


```r
plot(nyc_1910$geometry)
```

<div class="figure">
<img src="11-other-census-data_files/figure-html/plot-nyc-tracts-1.png" alt="Plot of NYC Census tracts in 1910 using an Albers Equal Area CRS" width="100%" />
<p class="caption">(\#fig:plot-nyc-tracts)Plot of NYC Census tracts in 1910 using an Albers Equal Area CRS</p>
</div>

The data reflect Census tracts for New York City, but appear rotated counter-clockwise. This is because the coordinate reference system used, `ESRI:100023`, is appropriate for the entire United States (in fact, it is the base CRS used for `tigris::shift_geometry()`), but will not be appropriate for any specific small area. As covered in Chapter 5, the **crsuggest** package helps identify more appropriate projected coordinate reference system options.


```r
library(crsuggest)
library(sf)

suggest_crs(nyc_1910)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:suggest-nyc-crs-show)Suggested CRS options for New York City</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> crs_code </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> crs_name </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> crs_type </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> crs_gcs </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> crs_units </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 6539 </td>
   <td style="text-align:left;"> NAD83(2011) / New York Long Island (ftUS) </td>
   <td style="text-align:left;"> projected </td>
   <td style="text-align:right;"> 6318 </td>
   <td style="text-align:left;"> us-ft </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 6538 </td>
   <td style="text-align:left;"> NAD83(2011) / New York Long Island </td>
   <td style="text-align:left;"> projected </td>
   <td style="text-align:right;"> 6318 </td>
   <td style="text-align:left;"> m </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4456 </td>
   <td style="text-align:left;"> NAD27 / New York Long Island </td>
   <td style="text-align:left;"> projected </td>
   <td style="text-align:right;"> 4267 </td>
   <td style="text-align:left;"> us-ft </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 3628 </td>
   <td style="text-align:left;"> NAD83(NSRS2007) / New York Long Island (ftUS) </td>
   <td style="text-align:left;"> projected </td>
   <td style="text-align:right;"> 4759 </td>
   <td style="text-align:left;"> us-ft </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 3627 </td>
   <td style="text-align:left;"> NAD83(NSRS2007) / New York Long Island </td>
   <td style="text-align:left;"> projected </td>
   <td style="text-align:right;"> 4759 </td>
   <td style="text-align:left;"> m </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 32118 </td>
   <td style="text-align:left;"> NAD83 / New York Long Island </td>
   <td style="text-align:left;"> projected </td>
   <td style="text-align:right;"> 4269 </td>
   <td style="text-align:left;"> m </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2908 </td>
   <td style="text-align:left;"> NAD83(HARN) / New York Long Island (ftUS) </td>
   <td style="text-align:left;"> projected </td>
   <td style="text-align:right;"> 4152 </td>
   <td style="text-align:left;"> us-ft </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2831 </td>
   <td style="text-align:left;"> NAD83(HARN) / New York Long Island </td>
   <td style="text-align:left;"> projected </td>
   <td style="text-align:right;"> 4152 </td>
   <td style="text-align:left;"> m </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2263 </td>
   <td style="text-align:left;"> NAD83 / New York Long Island (ftUS) </td>
   <td style="text-align:left;"> projected </td>
   <td style="text-align:right;"> 4269 </td>
   <td style="text-align:left;"> us-ft </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 3748 </td>
   <td style="text-align:left;"> NAD83(HARN) / UTM zone 18N </td>
   <td style="text-align:left;"> projected </td>
   <td style="text-align:right;"> 4152 </td>
   <td style="text-align:left;"> m </td>
  </tr>
</tbody>
</table>

Based on these suggestions, we'll select the CRS "NAD83(2011) / New York Long Island" which has an EPSG code of 6538.


```r
nyc_1910_proj <- st_transform(nyc_1910, 6538)

plot(nyc_1910_proj$geometry)
```

<div class="figure">
<img src="11-other-census-data_files/figure-html/transform-nyc-crs-1.png" alt="NYC Census tracts with an area-appropriate CRS" width="100%" />
<p class="caption">(\#fig:transform-nyc-crs)NYC Census tracts with an area-appropriate CRS</p>
</div>

Given the information in the two tables downloaded from NHGIS, there are multiple ways to visualize the demographics of New York City in 1910. The first example is a choropleth map of the percentage of the total population born outside the United States. As there is no "total population" column in the dataset, the code below uses **dplyr**'s `rowwise()` and `c_across()` functions to perform row-wise calculations and sum across the columns `A60001` through `A60007`. The `transmute()` function then works like a combination of `mutate()` and `select()`: it calculates two new columns, then selects only those columns in the output dataset `nyc_pctfb`.


```r
nyc_pctfb <- nyc_1910_proj %>%
  rowwise() %>%
  mutate(total = sum(c_across(A60001:A60007))) %>%
  ungroup() %>%
  transmute(
    tract_id = GISJOIN,
    pct_fb = A60005 / total
  ) 
```

The result can be visualized with any of the mapping packages covered in Chapter \@ref(mapping-census-data-with-r), such as ggplot2 and `geom_sf()`.


```r
ggplot(nyc_pctfb, aes(fill = pct_fb)) + 
  geom_sf(color = NA) + 
  scale_fill_viridis_c(option = "magma", labels = scales::percent) + 
  theme_void(base_family = "Verdana") + 
  labs(title = "Percent foreign-born by Census tract, 1910",
       subtitle = "New York City",
       caption =  "Data source: NHGIS",
       fill = "Percentage")
```

<div class="figure">
<img src="11-other-census-data_files/figure-html/map-nyc-fb-1.png" alt="Percent foreign-born by Census tract in NYC in 1910, mapped with ggplot2" width="100%" />
<p class="caption">(\#fig:map-nyc-fb)Percent foreign-born by Census tract in NYC in 1910, mapped with ggplot2</p>
</div>

Manhattan's Lower East Side stands out as the part of the city with the largest proportion of foreign-born residents in 1910, with percentages exceeding 60%.

An alternative view could focus on one of the specific groups represented in the columns in the dataset. For example, the number of Italy-born residents by Census tract is represented in the column `A6G014`; this type of information could be represented by either a graduated symbol map or a dot-density map. Using techniques learned in Section \@ref(dot-density-maps), `st_sample()` in the code below generates one dot for approximately every 100 Italian immigrants. Next, the Census tracts are dissolved with the `st_union()` function to generate a base layer on top of which the dots will be plotted.


```r
italy_dots <- nyc_1910_proj %>%
  st_sample(size = as.integer(.$A6G014 / 100)) %>%
  st_sf()

nyc_base <- nyc_1910_proj %>%
  st_union()
```



In Section \@ref(dot-density-maps), we used `tmap::tm_dots()` to create a dot-density map. ggplot2 and `geom_sf()` also work well for dot-density mapping; cartographers can either use `geom_sf()` with a very small `size` argument, or set `shape = "."` where each data point will be represented by a single pixel on the screen.


```r
ggplot() + 
  geom_sf(data = nyc_base, size = 0.1) + 
  geom_sf(data = italy_dots, shape = ".", color = "darkgreen") + 
  theme_void(base_family = "Verdana") + 
  labs(title = "Italy-born population in New York City, 1910",
       subtitle = "1 dot = 100 people",
       caption = "Data source: NHGIS")
```

<div class="figure">
<img src="11-other-census-data_files/figure-html/visualize-italy-dots-1.png" alt="Dot-density map of the Italy-born population in NYC in 1910, mapped with ggplot2" width="100%" />
<p class="caption">(\#fig:visualize-italy-dots)Dot-density map of the Italy-born population in NYC in 1910, mapped with ggplot2</p>
</div>

The resulting map highlights areas with large concentrations of Italian immigrants in New York City in 1910.

## Analyzing complete-count historical microdata with IPUMS and R

Chapters 9 and 10 covered the process of acquiring and analyzing microdata from the American Community Survey with **tidycensus**. As noted, these workflows are only available for recent demographics, reflecting the recent availability of the ACS. Historical researchers will need data that goes further back, and will likely turn to [IPUMS-USA](https://usa.ipums.org/usa/) for these datasets. IPUMS-USA makes available microdata samples all the way back to 1790, enabling historical demographic research not possible elsewhere.

A core focus of Chapter 10 was the use of sampling weights to appropriately analyze and model microdata. Historical Census datasets, however, are subject to the ["72-year rule"](https://www.census.gov/history/www/genealogy/decennial_census_records/the_72_year_rule_1.html), which states:

> The U.S. government will not release personally identifiable information about an individual to any other individual or agency until 72 years after it was collected for the decennial census. This "72-Year Rule" (92 Stat. 915; [Public Law 95-416](https://www.census.gov/history/pdf/NARA_Legislation.pdf); October 5, 1978) restricts access to decennial census records to all but the individual named on the record or their legal heir.

This means that decennial Census records that reflect periods 72 years ago or older can be made available to researchers by the IPUMS team. In fact, complete-count Census microdata can be downloaded from IPUMS at the person-level for the Census years 1850-1940, and at the household level for years earlier than 1850.

The availability of complete-count Census records offers a tremendous analytic opportunity for researchers, but also comes with some challenges. The largest ACS microdata sample - the 2015-2019 5-year ACS - has around 16 million records, which can be read into memory on a standard desktop computer with 16GB RAM. Complete-count Census data can have records exceeding 100 million, which will not be possible to read into memory in R on a standard computer. This chapter covers R-based workflows for handling massive Census microdata without needing to upgrade one's computer or set up a cloud computing instance. The solution presented involves setting up a local database with PostgreSQL and the DBeaver platform, then interacting with microdata in that database using R's tidyverse and database interface tooling.

### Getting microdata from IPUMS

To get started, visit the IPUMS-USA website at <https://usa.ipums.org/usa/>. If you already signed up for an IPUMS account in Section \@ref(getting-started-with-nhgis), log in with your user name and password; otherwise follow those instructions to register for an account, which you can use for all of the IPUMS resources including NHGIS. Once you are logged in, click the "Get Data" button to visit the data selection menu.

<div class="figure">
<img src="img/screenshots/ipums-get-data.png" alt="IPUMS data browser" width="100%" />
<p class="caption">(\#fig:ipums-get-data)IPUMS data browser</p>
</div>

You'll use the various options displayed in the image above to define your extract. These options include:

-   **Select samples**: choose one or more data samples to include in your microdata extract. You can choose a wide range of American Community Survey and Decennial US Census samples, or you can download full count Census data from the "USA FULL COUNT" tab. To reproduce this example, choose the 1910 100% dataset by first un-checking the "Default sample from each year" box, clicking the "USA FULL COUNT" tab, then choosing the 1910 dataset and clicking **SUBMIT SAMPLE SELECTIONS**.

-   **Select harmonized variables**: One of the major benefits of using IPUMS for microdata analysis is that the IPUMS team has produced *harmonized variables* that aim to reconcile variable IDs and variable definitions over time allowing for easier longitudinal analysis. By default, users will browse and select from these harmonized variables. Choose from household-level variables and person-level variables by browsing the drop-down menus and selecting appropriate variable IDs; these will be added to your output extract. For users who want to work with variables as they originally were in the source dataset, click the **SOURCE VARIABLES** radio button to switch to source variables. To replicate this example, choose the STATEFIP (household \> geographic), SEX, AGE, and MARST (person \> demographic), and LIT (person \> education) variables.

-   **Display options:** This menu gives a number of options to modify the display of variables when browsing; try out the different options if you'd like.

When finished, click the "VIEW CART" link to go to your data cart. You'll see the variables that will be returned with your extract.

<div class="figure">
<img src="img/screenshots/ipums-data-cart.png" alt="IPUMS data cart" width="100%" />
<p class="caption">(\#fig:ipums-data-cart)IPUMS data cart</p>
</div>

Notice that there will be more variables in your output extract than you selected; this is because a number of technical variables are *pre-selected,* which is similar to the approach taken by `get_pums()` in **tidycensus**. When you are ready to create the extract, click the **CREATE DATA EXTRACT** button to get a summary of your extract before submitting.

<div class="figure">
<img src="img/screenshots/ipums-extract-request.png" alt="IPUMS extract request screen" width="100%" />
<p class="caption">(\#fig:ipums-extract-request)IPUMS extract request screen</p>
</div>

Note that the example shown reflects changing the output data format to CSV, which will be used to load the IPUMS data into a database. If using R directly for a smaller extract and the **ipumsr** R package, the default fixed-width text file with the extension `.dat` can be selected and the data can be read into R with `ipumsr::read_ipums_micro()`. To replicate the workflow below, however, the output data format should be changed to CSV.

Click **SUBMIT EXTRACT** to submit your extract request to the IPUMS system. You'll need to agree to some special usage terms for the 100% data, then wait patiently for your extract to process. You'll get an email notification when your extract is ready; when you do, return to IPUMS and download your data extract to your computer. The output format will be a gzipped CSV with a prefix unique to your download ID, e.g. `usa_00032.csv.gz`. Use an appropriate utility to unzip the CSV file.

### Loading microdata into a database

Census data analysts may feel comfortable working with `.csv` files, and reading them into R with `readr::read_csv()` or one of the many other options for loading data from comma-separated text files. The data extract created in the previous section presents additional challenges for the Census analyst, however. It contains approximately 92.4 million rows - one for each person in the 1910 US Census! This will fill up the memory of a standard laptop computer when read into R very quickly using standard tools.

An alternative solution that can be performed on a standard laptop computer is setting up a database. The solution proposed here uses [PostgreSQL](https://www.postgresql.org/), a popular open-source database, and [DBeaver](https://dbeaver.io/), a free cross-platform tool for working with databases.

If PostgreSQL is not already installed on your computer, visit <https://www.postgresql.org/download/> and follow the instructions for your operating system to install it. A full tutorial on PostgreSQL for each operating system is beyond the scope of this book, so this example will use standard defaults. When you are finished installing PostgreSQL, you will be prompted to set up a default database, which will be called `postgres` and will be associated with a user, also named `postgres`. You'll be asked to set a password for the database; the examples in this chapter also use `postgres` for the password, but you can choose whatever password you would like.

Once the default database has been set up, visit <https://dbeaver.io/download/> and download/install the appropriate DBeaver Community Edition for your operating system. Launch DBeaver, and look for the "New Database Connection" icon. Click there to launch a connection to your PostgreSQL database. Choose "PostgreSQL" from the menu of database options and fill out your connection settings appropriately.

<div class="figure">
<img src="img/screenshots/dbeaver-connect.png" alt="DBeaver connection screen" width="100%" />
<p class="caption">(\#fig:dbeaver-connect)DBeaver connection screen</p>
</div>

For most defaults, the host should be `localhost` running on port `5432` with the database name `postgres` and the username `postgres` as well. Enter the password you selected when setting up PostgreSQL and click **Finish**. You'll notice your database connection appear in the "Database Navigator" pane of DBeaver.

Within the database, you can create **schemas** to organize sets of related tables. To create a new schema, right-click the postgres database in the Database Navigator pane and choose "Create \> Schema". This example uses a schema named "ipums". Within the new schema you'll be able to import your CSV file as a table. Expand the "ipums" schema and right-click on "Tables" then choose **Import Data.** Select the unzipped IPUMS CSV file and progress through the menus. This example changes the default "Target" name to `census1910`.

On the final menu, click the **Start** button to import your data. Given the size of the dataset, this will likely take some time; it took around 2 hours to prepare the example on my machine. Once the data has imported successfully to the new database table in DBeaver, you'll be able to inspect your dataset using the DBeaver interface.

<div class="figure">
<img src="img/screenshots/dbeaver-data-view.png" alt="DBeaver data view" width="100%" />
<p class="caption">(\#fig:dbeaver-data-view)DBeaver data view</p>
</div>

### Accessing your microdata database with R

In a typical R workflow with flat files, an analyst will read in a dataset (such as a CSV file) entirely in-memory into R then use their preferred toolset to interact with the data. The alternative discussed in this section involves connecting to the 1910 Census database from R then using R's database interface toolkit through the tidyverse to analyze the data. A major benefit to this workflow is that it allows an analyst to perform tidyverse operations on datasets *in the database*. This means that tidyverse functions are translated to Structured Query Language (SQL) queries and passed to the database, with outputs displayed in R, allowing the analyst to interact with data without having to read it into memory.

The first step requires making a database connection from R. [The DBI infrastructure for R](https://www.r-dbi.org/) allows users to make connections to a wide range of databases using a consistent interface [@dbi2021]. The PostgreSQL interface is handled with the **RPostgres** package [@wickham2021_rpostgres].

The `dbConnect()` function is used to make a database connection, which will be assigned to the object `conn`. Arguments include the database driver `Postgres()` and the username, password, database name, host, and port, which are all familiar from the database setup process.


```r
library(tidyverse)
library(RPostgres)
library(dbplyr)

conn <- dbConnect(
  drv = Postgres(),
  user = "postgres",
  password = "postgres",
  host = "localhost",
  port = "5432",
  dbname = "postgres"
)
```

Once connected to the database, the database extension to **dplyr**, **dbplyr**, facilitates interaction with database tables [@wickham2021_dbplyr]. `tbl()` links to the connection object `conn` to retrieve data from the database; the `in_schema()` function points `tbl()` to the `census1910` table in the `ipums` schema.

Printing the new object `census1910` shows the general structure of the 1910 Census microdata:


```r
census1910 <- tbl(conn, in_schema("ipums", "census1910"))

census1910
```

```
## # Source:   table<"ipums"."census1910"> [?? x 13]
## # Database: postgres [postgres@localhost:5432/postgres]
##     YEAR sample serial  hhwt statefip    gq pernum perwt   sex   age marst   lit
##    <int>  <int>  <int> <dbl>    <int> <int>  <int> <dbl> <int> <int> <int> <int>
##  1  1910 191004      1     1        2     1      1     1     1    43     6     4
##  2  1910 191004      2     1        2     1      1     1     1    34     6     4
##  3  1910 191004      3     1        2     1      1     1     1    41     1     4
##  4  1910 191004      3     1        2     1      2     1     2    39     1     4
##  5  1910 191004      3     1        2     1      3     1     1    37     6     4
##  6  1910 191004      4     1        2     1      1     1     1    24     6     4
##  7  1910 191004      5     1        2     1      1     1     1    24     6     4
##  8  1910 191004      5     1        2     1      2     1     1    35     6     4
##  9  1910 191004      5     1        2     1      3     1     1    45     2     4
## 10  1910 191004      5     1        2     1      4     1     1    55     6     4
## # … with more rows, and 1 more variable: histid <chr>
```

Our data have 13 columns and an unknown number of rows; the database table is so large that **dbplyr** won't calculate this automatically. However, the connection to the database allows for interaction with the 1910 Census microdata using familiar tidyverse workflows, which are addressed in the next section.

### Analyzing big Census microdata in R

While the default printing of the microdata shown above does not reveal the number of rows in the dataset, tidyverse tools can be used to request this information from the database. For example, the `summarize()` function will generate summary tabulations as shown earlier in this book; without a companion `group_by()`, it will do so over the whole dataset.


```r
census1910 %>% summarize(n())
```

```
## # Source:   lazy query [?? x 1]
## # Database: postgres [postgres@localhost:5432/postgres]
##      `n()`
##    <int64>
## 1 92404011
```

There are 92.4 million rows in the dataset, reflecting the US population size in 1910. Given that we are working with complete-count data, the workflow for using microdata differs from the sample data covered in Chapters 9 and 10. While IPUMS by default returns a person-weight column, the value for all rows in the dataset for this column is 1, reflecting a 1:1 relationship between the records and actual people in the United States at that time.

**dplyr**'s database interface can accommodate more complex examples as well. Let's say we want to tabulate literacy statistics in 1910 for the population age 18 and up in Texas by sex. A straightforward tidyverse pipeline can accommodate this request to the database. For reference, male is coded as 1 and female as 2, and the literacy codes are as follows:

-   1: No, illiterate (cannot read or write)

-   2: Cannot read, can write

-   3: Cannot write, can read

-   4: Yes, literate (reads and writes)


```r
census1910 %>%
  filter(age > 17, statefip == "48") %>%
  group_by(sex, lit) %>%
  summarize(num = n())
```

```
## # Source:   lazy query [?? x 3]
## # Database: postgres [postgres@localhost:5432/postgres]
## # Groups:   sex
##     sex   lit     num
##   <int> <int> <int64>
## 1     1     1  115952
## 2     1     2      28
## 3     1     3   14183
## 4     1     4  997844
## 5     2     1  111150
## 6     2     2      16
## 7     2     3   14531
## 8     2     4  883636
```

dbplyr also includes some helper functions to better understand how it is working and to work with the derived results. For example, the `show_query()` function can be attached to the end of a tidyverse pipeline to show the SQL query that the R code is translated to in order to perform operations in-database:


```r
census1910 %>%
  filter(age > 17, statefip == "48") %>%
  group_by(sex, lit) %>%
  summarize(num = n()) %>%
  show_query()
```

```
## <SQL>
## SELECT "sex", "lit", COUNT(*) AS "num"
## FROM "ipums"."census1910"
## WHERE (("age" > 17.0) AND ("statefip" = '48'))
## GROUP BY "sex", "lit"
```

If an analyst wants the result of a database operation to be brought into R as an R object rather than as a database view, the `collect()` function can be used at the end of a pipeline to load data directly. A companion function from **ipumsr**, `ipums_collect()`, will add variable and value labels to the collected data based on an IPUMS codebook.

The aforementioned toolsets can now be used for robust analyses of historical microdata based on complete-count Census data. The example below illustrates how to extend the literacy by sex example above to visualize literacy gaps by sex by state in 1910.


```r
literacy_props <- census1910 %>%
  filter(age > 18) %>%
  group_by(statefip, sex, lit) %>%
  summarize(num = n()) %>%
  group_by(statefip, sex) %>%
  mutate(total = sum(num, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(prop = num / total) %>%
  filter(lit == 4) %>%
  collect()

state_names <- tigris::fips_codes %>%
  select(state_code, state_name) %>%
  distinct()

literacy_props_with_name <- literacy_props %>%
  mutate(statefip = str_pad(statefip, 2, "left", "0")) %>%
  left_join(state_names, by = c("statefip" = "state_code")) %>%
  mutate(sex = ifelse(sex == 1, "Male", "Female")) 

ggplot(literacy_props_with_name, aes(x = prop, y = reorder(state_name, prop), 
                           color = sex)) + 
  geom_line(aes(group = state_name), color = "grey10") + 
  geom_point(size = 2.5) +
  theme_minimal() + 
  scale_color_manual(values = c(Male = "navy", Female = "darkred")) + 
  scale_x_continuous(labels = scales::percent) + 
  labs(x = "Percent fully literate, 1910",
       color = "",
       y = "")
```

<div class="figure">
<img src="img/screenshots/literacy-1910.png" alt="Literacy gaps by sex and state in 1910" width="100%" />
<p class="caption">(\#fig:literacy-1910)Literacy gaps by sex and state in 1910</p>
</div>

## Other US government datasets

To this point, this book has focused on a smaller number of US Census Bureau datasets, with a primary focus on the decennial US Census and the American Community Survey. However, many more US government datasets are available to researchers, some from the US Census Bureau and others from different US government agencies. This section covers a series of R packages to help analysts access these resources, and illustrates some applied workflows using those datasets.

### Accessing Census data resources with censusapi

**censusapi** [@recht2021] is an R package designed to give R users access to *all* of the US Census Bureau's API endpoints. Unlike **tidycensus**, which only focuses on a select number of datasets, **censusapi**'s `getCensus()` function can be widely applied to the hundreds of possible datasets the Census Bureau makes available. **censusapi** requires some knowledge of how to structure Census Bureau API requests to work; however this makes the package more flexible than **tidycensus** and may be preferable for users who want to submit highly customized queries to the decennial Census or ACS APIs.

censusapi uses the same Census API key as **tidycensus**, though references it with the R environment variable `CENSUS_KEY`. If this environment variable is set in a user's `.Renviron` file, functions in **censusapi** will pick up the key without having to supply it directly.

The **usethis** package [@wickham_and_bryan2021] is the most user-friendly way to work with the `.Renviron` file in R with its function `edit_r_environ()`. Calling this function will bring up the `.Renviron` file in a text editor, allowing users to set environment variables that will be made available to R when R starts up.


```r
library(usethis)

edit_r_environ()
```

Add the line `CENSUS_KEY='YOUR KEY HERE'` to your `.Renviron` file, replacing the `YOUR KEY HERE` text with your API key.

**censusapi**'s core function is `getCensus()`, which translates R code to Census API queries. The `name` argument references the API name; the [censusapi documentation](https://www.hrecht.com/censusapi/articles/example-masterlist.html) or the function `listCensusApis()` helps you understand how to format this.

The example below makes a request to the [Economic Census API](https://www.census.gov/programs-surveys/economic-census/data/api.html), getting data on employment and payroll for NAICS code 72 (accommodation and food services businesses) in counties in Texas in 2017.


```r
library(censusapi)

tx_econ17 <- getCensus(
  name = "ecnbasic",
  vintage = 2017,
  vars = c("EMP", "PAYANN", "GEO_ID"),
  region = "county:*",
  regionin = "state:48",
  NAICS2017 = 72
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:censusapi-show)Data from the 2017 Economic Census acquired with the censusapi package</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> state </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> county </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> EMP </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> PAYANN </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEO_ID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAICS2017 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 48 </td>
   <td style="text-align:left;"> 373 </td>
   <td style="text-align:left;"> 1041 </td>
   <td style="text-align:left;"> 15256 </td>
   <td style="text-align:left;"> 0500000US48373 </td>
   <td style="text-align:left;"> 72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 48 </td>
   <td style="text-align:left;"> 391 </td>
   <td style="text-align:left;"> 246 </td>
   <td style="text-align:left;"> 3242 </td>
   <td style="text-align:left;"> 0500000US48391 </td>
   <td style="text-align:left;"> 72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 48 </td>
   <td style="text-align:left;"> 389 </td>
   <td style="text-align:left;"> 664 </td>
   <td style="text-align:left;"> 14641 </td>
   <td style="text-align:left;"> 0500000US48389 </td>
   <td style="text-align:left;"> 72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 48 </td>
   <td style="text-align:left;"> 055 </td>
   <td style="text-align:left;"> 910 </td>
   <td style="text-align:left;"> 15247 </td>
   <td style="text-align:left;"> 0500000US48055 </td>
   <td style="text-align:left;"> 72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 48 </td>
   <td style="text-align:left;"> 487 </td>
   <td style="text-align:left;"> 394 </td>
   <td style="text-align:left;"> 5233 </td>
   <td style="text-align:left;"> 0500000US48487 </td>
   <td style="text-align:left;"> 72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 48 </td>
   <td style="text-align:left;"> 383 </td>
   <td style="text-align:left;"> 140 </td>
   <td style="text-align:left;"> 2178 </td>
   <td style="text-align:left;"> 0500000US48383 </td>
   <td style="text-align:left;"> 72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 48 </td>
   <td style="text-align:left;"> 481 </td>
   <td style="text-align:left;"> 1271 </td>
   <td style="text-align:left;"> 16621 </td>
   <td style="text-align:left;"> 0500000US48481 </td>
   <td style="text-align:left;"> 72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 48 </td>
   <td style="text-align:left;"> 493 </td>
   <td style="text-align:left;"> 940 </td>
   <td style="text-align:left;"> 11745 </td>
   <td style="text-align:left;"> 0500000US48493 </td>
   <td style="text-align:left;"> 72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 48 </td>
   <td style="text-align:left;"> 255 </td>
   <td style="text-align:left;"> 476 </td>
   <td style="text-align:left;"> 8163 </td>
   <td style="text-align:left;"> 0500000US48255 </td>
   <td style="text-align:left;"> 72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 48 </td>
   <td style="text-align:left;"> 067 </td>
   <td style="text-align:left;"> 670 </td>
   <td style="text-align:left;"> 7387 </td>
   <td style="text-align:left;"> 0500000US48067 </td>
   <td style="text-align:left;"> 72 </td>
  </tr>
</tbody>
</table>

**censusapi** can also be used in combination with other packages covered in this book such as **tigris** for mapping. The example below uses the [Small Area Health Insurance Estimates API](https://www.census.gov/programs-surveys/sahie/data/api.html), which delivers modeled estimates of health insurance coverage at the county level with various demographic breakdowns. Using **censusapi** and **tigris**, we can retrieve data on the percent of the population below age 19 without health insurance for all counties in the US. This information will be joined to a counties dataset from **tigris** with shifted geometry, then mapped with **ggplot2**.


```r
library(tigris)
library(tidyverse)

us_youth_sahie <- getCensus(
  name = "timeseries/healthins/sahie",
  vars = c("GEOID", "PCTUI_PT"),
  region = "county:*",
  regionin = "state:*",
  time = 2019,
  AGECAT = 4
)

us_counties <- counties(cb = TRUE, resolution = "20m", year = 2019) %>%
  shift_geometry(position = "outside") %>%
  inner_join(us_youth_sahie, by = "GEOID") 

ggplot(us_counties, aes(fill = PCTUI_PT)) + 
  geom_sf(color = NA) + 
  theme_void() + 
  scale_fill_viridis_c() + 
  labs(fill = "% uninsured ",
       caption = "Data source: US Census Bureau Small Area\nHealth Insurance Estimates via the censusapi R package",
       title = "  Percent uninsured under age 19 by county, 2019")
```

<div class="figure">
<img src="11-other-census-data_files/figure-html/map-sahie-1.png" alt="Map of youth without health insurance using censusapi and tigris" width="100%" />
<p class="caption">(\#fig:map-sahie)Map of youth without health insurance using censusapi and tigris</p>
</div>

As these are *modeled* estimates, state-level influences on the county-level estimates are apparent on the map.

### Analyzing labor markets with lehdr

Another very useful package for working with Census Bureau data is the **lehdr** R package [@green2021], which access the Longitudinal and Employer-Household Dynamics (LEHD) Origin-Destination Employment Statistics (LODES) data. LODES is not available from the Census API, meriting an alternative package and approach. LODES includes synthetic estimates of residential, workplace, and residential-workplace links at the Census block level, allowing for highly detailed geographic analysis of jobs and commuter patterns over time.

The core function implemented in **lehdr** is `grab_lodes()`, which downloads a LODES file of a specified `lodes_type` (either `"rac"` for residential, `"wac"` for workplace, or `"od"` for origin-destination) for a given state and year. While the raw LODES data are available at the Census block level, the `agg_geo` parameter offers a convenient way to roll up estimates to higher levels of aggregation. For origin-destination data, the `state_part = "main"` argument below captures within-state commuters; use `state_part = "aux"` to get commuters from out-of-state.


```r
library(lehdr)
library(tidycensus)
library(sf)
library(tidyverse)

wa_lodes_od <- grab_lodes(
  state = "wa",
  year = 2018,
  lodes_type = "od",
  agg_geo = "tract",
  state_part = "main"
)
```

The result is a dataset that shows tract-to-tract commute flows (`S000`) and broken down by a variety of characteristics, [referenced in the LODES documentation](https://lehd.ces.census.gov/data/lodes/LODES7/LODESTechDoc7.5.pdf).

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:show-wa-lodes)Origin-destination data acquired with the lehdr package</caption>
 <thead>
  <tr>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> year </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> state </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> w_tract </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> h_tract </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> S000 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> SA01 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> SA02 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> SA03 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> SE01 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> SE02 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> SE03 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> SI01 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> SI02 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> SI03 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:left;"> WA </td>
   <td style="text-align:left;"> 53001950100 </td>
   <td style="text-align:left;"> 53001950100 </td>
   <td style="text-align:right;"> 515 </td>
   <td style="text-align:right;"> 109 </td>
   <td style="text-align:right;"> 241 </td>
   <td style="text-align:right;"> 165 </td>
   <td style="text-align:right;"> 203 </td>
   <td style="text-align:right;"> 170 </td>
   <td style="text-align:right;"> 142 </td>
   <td style="text-align:right;"> 31 </td>
   <td style="text-align:right;"> 91 </td>
   <td style="text-align:right;"> 393 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:left;"> WA </td>
   <td style="text-align:left;"> 53001950100 </td>
   <td style="text-align:left;"> 53001950200 </td>
   <td style="text-align:right;"> 75 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 40 </td>
   <td style="text-align:right;"> 23 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 62 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:left;"> WA </td>
   <td style="text-align:left;"> 53001950100 </td>
   <td style="text-align:left;"> 53001950300 </td>
   <td style="text-align:right;"> 23 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 19 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:left;"> WA </td>
   <td style="text-align:left;"> 53001950100 </td>
   <td style="text-align:left;"> 53001950400 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 13 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:left;"> WA </td>
   <td style="text-align:left;"> 53001950100 </td>
   <td style="text-align:left;"> 53001950500 </td>
   <td style="text-align:right;"> 27 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 26 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:left;"> WA </td>
   <td style="text-align:left;"> 53001950100 </td>
   <td style="text-align:left;"> 53003960100 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:left;"> WA </td>
   <td style="text-align:left;"> 53001950100 </td>
   <td style="text-align:left;"> 53003960300 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:left;"> WA </td>
   <td style="text-align:left;"> 53001950100 </td>
   <td style="text-align:left;"> 53003960400 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:left;"> WA </td>
   <td style="text-align:left;"> 53001950100 </td>
   <td style="text-align:left;"> 53003960500 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:left;"> WA </td>
   <td style="text-align:left;"> 53001950100 </td>
   <td style="text-align:left;"> 53005010201 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
</tbody>
</table>

**lehdr** can be used for a variety of purposes including transportation and economic development planning. For example, the workflow below illustrates how to use LODES data to understand the origins of commuters to the Microsoft campus (represented by its Census tract) in Redmond, Washington. Commuters from LODES will be normalized by the total population age 18 and up, acquired with tidycensus for 2018 Census tracts in Seattle-area counties. The dataset `ms_commuters` will include Census tract geometries (obtained with `geometry = TRUE` in tidycensus) and an estimate of the number of Microsoft-area commuters per 1000 adults in that Census tract.


```r
seattle_adults <- get_acs(
  geography = "tract",
  variables = "S0101_C01_026",
  state = "WA",
  county = c("King", "Kitsap", "Pierce",
             "Snohomish"),
  year = 2018,
  geometry = TRUE
)

microsoft <- filter(wa_lodes_od, w_tract == "53033022803")

ms_commuters <- seattle_adults %>%
  left_join(microsoft, by = c("GEOID" = "h_tract")) %>%
  mutate(ms_per_1000 = 1000 * (S000 / estimate)) %>%
  st_transform(6596)
```

The result can be visualized on a map with **ggplot2**, or alternatively with any of the mapping tools introduced in Chapter \@ref(mapping-census-data-with-r).


```r
ggplot(ms_commuters, aes(fill = ms_per_1000)) + 
  geom_sf(color = NA) + 
  theme_void() + 
  scale_fill_viridis_c(option = "cividis") + 
  labs(title = "Microsoft commuters per 1000 adults",
       subtitle = "2018 LODES data, Seattle-area counties",
       fill = "Rate per 1000")
```

<div class="figure">
<img src="11-other-census-data_files/figure-html/ms-commuters-map-1.png" alt="Map of commuter origins to the Microsoft Campus area, Seattle-area counties" width="100%" />
<p class="caption">(\#fig:ms-commuters-map)Map of commuter origins to the Microsoft Campus area, Seattle-area counties</p>
</div>

### Bureau of Labor Statistics data with blscrapeR

Another essential resource for data on US labor market characteristics is the [Bureau of Labor Statistics](https://www.bls.gov/), which makes their data available to users via an API. BLS data can be accessed from R with the **blscrapeR** package [@eberwein2021]. Like other government APIs, the BLS API requires an API key, obtained from <https://data.bls.gov/registrationEngine/>. Sign up with an email address then validate the key using the link sent to your email, then return to R to get started with **blscrapeR**.


```r
# remotes::install_github("keberwein/blscrapeR")
library(blscrapeR)

set_bls_key("YOUR KEY HERE")
```

**blscrapeR** includes a number of helper functions to assist users with some of the most commonly requested statistics. For example, the `get_bls_county()` function fetches employment data for all counties in the US for a given month.


```r
latest_employment <- get_bls_county("May 2021")
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:show-bls-county)May 2021 employment data from the BLS</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> area_code </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> fips_state </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> fips_county </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> area_title </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> period </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> labor_force </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> employed </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> unemployed </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> unemployed_rate </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> fips </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> CN0100100000000 </td>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> 001 </td>
   <td style="text-align:left;"> Autauga County, AL </td>
   <td style="text-align:left;"> 2021-05-01 </td>
   <td style="text-align:right;"> 25580 </td>
   <td style="text-align:right;"> 24993 </td>
   <td style="text-align:right;"> 587 </td>
   <td style="text-align:right;"> 2.3 </td>
   <td style="text-align:left;"> 01001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CN0100300000000 </td>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> 003 </td>
   <td style="text-align:left;"> Baldwin County, AL </td>
   <td style="text-align:left;"> 2021-05-01 </td>
   <td style="text-align:right;"> 99524 </td>
   <td style="text-align:right;"> 97175 </td>
   <td style="text-align:right;"> 2349 </td>
   <td style="text-align:right;"> 2.4 </td>
   <td style="text-align:left;"> 01003 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CN0100500000000 </td>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> 005 </td>
   <td style="text-align:left;"> Barbour County, AL </td>
   <td style="text-align:left;"> 2021-05-01 </td>
   <td style="text-align:right;"> 8103 </td>
   <td style="text-align:right;"> 7732 </td>
   <td style="text-align:right;"> 371 </td>
   <td style="text-align:right;"> 4.6 </td>
   <td style="text-align:left;"> 01005 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CN0100700000000 </td>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> 007 </td>
   <td style="text-align:left;"> Bibb County, AL </td>
   <td style="text-align:left;"> 2021-05-01 </td>
   <td style="text-align:right;"> 8555 </td>
   <td style="text-align:right;"> 8293 </td>
   <td style="text-align:right;"> 262 </td>
   <td style="text-align:right;"> 3.1 </td>
   <td style="text-align:left;"> 01007 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CN0100900000000 </td>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> 009 </td>
   <td style="text-align:left;"> Blount County, AL </td>
   <td style="text-align:left;"> 2021-05-01 </td>
   <td style="text-align:right;"> 24709 </td>
   <td style="text-align:right;"> 24238 </td>
   <td style="text-align:right;"> 471 </td>
   <td style="text-align:right;"> 1.9 </td>
   <td style="text-align:left;"> 01009 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CN0101100000000 </td>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> 011 </td>
   <td style="text-align:left;"> Bullock County, AL </td>
   <td style="text-align:left;"> 2021-05-01 </td>
   <td style="text-align:right;"> 4572 </td>
   <td style="text-align:right;"> 4423 </td>
   <td style="text-align:right;"> 149 </td>
   <td style="text-align:right;"> 3.3 </td>
   <td style="text-align:left;"> 01011 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CN0101300000000 </td>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> 013 </td>
   <td style="text-align:left;"> Butler County, AL </td>
   <td style="text-align:left;"> 2021-05-01 </td>
   <td style="text-align:right;"> 8674 </td>
   <td style="text-align:right;"> 8290 </td>
   <td style="text-align:right;"> 384 </td>
   <td style="text-align:right;"> 4.4 </td>
   <td style="text-align:left;"> 01013 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CN0101500000000 </td>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> 015 </td>
   <td style="text-align:left;"> Calhoun County, AL </td>
   <td style="text-align:left;"> 2021-05-01 </td>
   <td style="text-align:right;"> 45766 </td>
   <td style="text-align:right;"> 44199 </td>
   <td style="text-align:right;"> 1567 </td>
   <td style="text-align:right;"> 3.4 </td>
   <td style="text-align:left;"> 01015 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CN0101700000000 </td>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> 017 </td>
   <td style="text-align:left;"> Chambers County, AL </td>
   <td style="text-align:left;"> 2021-05-01 </td>
   <td style="text-align:right;"> 15513 </td>
   <td style="text-align:right;"> 15016 </td>
   <td style="text-align:right;"> 497 </td>
   <td style="text-align:right;"> 3.2 </td>
   <td style="text-align:left;"> 01017 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CN0101900000000 </td>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> 019 </td>
   <td style="text-align:left;"> Cherokee County, AL </td>
   <td style="text-align:left;"> 2021-05-01 </td>
   <td style="text-align:right;"> 11090 </td>
   <td style="text-align:right;"> 10848 </td>
   <td style="text-align:right;"> 242 </td>
   <td style="text-align:right;"> 2.2 </td>
   <td style="text-align:left;"> 01019 </td>
  </tr>
</tbody>
</table>

More complex queries are also possible with the `bls_api()` function; however, this requires knowing the BLS *series ID*. Series IDs are composite strings made up of several alphanumeric codes that can represent different datasets, geographies, and industries, among others. **blscrapeR** includes an internal dataset, `series_ids`, to help users view some of the most commonly requested IDs.


```r
head(series_ids)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:show-series-ids)Series IDs for use in blscrapeR</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> series_title </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> series_id </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> seasonal </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> periodicity_code </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> (Seas) Population Level </td>
   <td style="text-align:left;"> LNS10000000 </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> M </td>
  </tr>
  <tr>
   <td style="text-align:left;"> (Seas) Population Level </td>
   <td style="text-align:left;"> LNS10000000Q </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> Q </td>
  </tr>
  <tr>
   <td style="text-align:left;"> (Seas) Population Level - Men </td>
   <td style="text-align:left;"> LNS10000001 </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> M </td>
  </tr>
  <tr>
   <td style="text-align:left;"> (Seas) Population Level - Men </td>
   <td style="text-align:left;"> LNS10000001Q </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> Q </td>
  </tr>
  <tr>
   <td style="text-align:left;"> (Seas) Population Level - Women </td>
   <td style="text-align:left;"> LNS10000002 </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> M </td>
  </tr>
  <tr>
   <td style="text-align:left;"> (Seas) Population Level - Women </td>
   <td style="text-align:left;"> LNS10000002Q </td>
   <td style="text-align:left;"> S </td>
   <td style="text-align:left;"> Q </td>
  </tr>
</tbody>
</table>

`series_ids` only contains indicators from the Current Population Survey and Local Area Unemployment Statistics databases. Other data series can be constructed by following the instructions on [\<https://www.bls.gov/help/hlpforma.htm\>](https://www.bls.gov/help/hlpforma.htm){.uri}. The example below illustrates this for data on the [Current Employment Statistics](https://www.bls.gov/ces/), for which the series ID [is formatted as follows](https://www.bls.gov/help/hlpforma.htm#SA):

-   Positions 1-2: The prefix (in this example, `SA`)

-   Position 3: The seasonal adjustment code (either `S`, for seasonally adjusted, or `U`, for unadjusted)

-   Positions 4-5: The two-digit state FIPS code

-   Positions 6-10: The [five-digit area code](https://download.bls.gov/pub/time.series/sm/sm.area), which should be set to `00000` if an entire state is requested.

-   Positions 11-18: The [super sector/industry code](https://download.bls.gov/pub/time.series/sm/sm.industry)

-   Positions 19-20: The [data type code](https://download.bls.gov/pub/time.series/sm/sm.data_type)

We'll use this information to get unadjusted data on accommodation workers in Maui, Hawaii since the beginning of 2018. Note that the specific codes detailed above will vary from indicator to indicator, and that not all industries will be available for all geographies.


```r
maui_accom <- bls_api(seriesid = "SMU15279807072100001", 
                      startyear = 2018)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:show-maui)Accommodations employment in Maui, Hawaii</caption>
 <thead>
  <tr>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> year </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> period </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> periodName </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> latest </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> value </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> footnotes </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> seriesID </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 2021 </td>
   <td style="text-align:left;"> M11 </td>
   <td style="text-align:left;"> November </td>
   <td style="text-align:left;"> true </td>
   <td style="text-align:right;"> 9.5 </td>
   <td style="text-align:left;"> P Preliminary </td>
   <td style="text-align:left;"> SMU15279807072100001 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2021 </td>
   <td style="text-align:left;"> M10 </td>
   <td style="text-align:left;"> October </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 9.3 </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> SMU15279807072100001 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2021 </td>
   <td style="text-align:left;"> M09 </td>
   <td style="text-align:left;"> September </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 9.5 </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> SMU15279807072100001 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2021 </td>
   <td style="text-align:left;"> M08 </td>
   <td style="text-align:left;"> August </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 9.7 </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> SMU15279807072100001 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2021 </td>
   <td style="text-align:left;"> M07 </td>
   <td style="text-align:left;"> July </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 9.6 </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> SMU15279807072100001 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2021 </td>
   <td style="text-align:left;"> M06 </td>
   <td style="text-align:left;"> June </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 8.9 </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> SMU15279807072100001 </td>
  </tr>
</tbody>
</table>

This time series can be visualized with **ggplot2**:


```r
maui_accom %>%
  mutate(period_order = rev(1:nrow(.))) %>%
  ggplot(aes(x = period_order, y = value, group = 1)) + 
  geom_line(color = "darkgreen") + 
  theme_minimal() + 
  scale_y_continuous(limits = c(0, max(maui_accom$value) + 1)) + 
  scale_x_continuous(breaks = seq(1, 42, 12),
                     labels = paste("Jan", 2018:2021)) + 
  labs(x = "",
       y = "Number of jobs (in 1000s)",
       title = "Accommodation employment in Maui, Hawaii",
       subtitle = "Data source: BLS Current Employment Statistics")
```

<div class="figure">
<img src="11-other-census-data_files/figure-html/plot-maui-1.png" alt="Time-series of accommodations employment in Maui, Hawaii" width="100%" />
<p class="caption">(\#fig:plot-maui)Time-series of accommodations employment in Maui, Hawaii</p>
</div>

The data suggest a stable accommodations sector prior to the onset of the COVID-19 pandemic, with recovery in the industry starting toward the end of 2020.

### Working with agricultural data with tidyUSDA

Agriculture can be a difficult sector on which to collect market statistics, as it is not available in many data sources such as LODES or the BLS Current Employment Statistics. Dedicated statistics on US agriculture can be acquired with the **tidyUSDA** R package [@lindblad2021], which interacts with USDA data resources using tidyverse-centric workflows. Get an API key at <https://quickstats.nass.usda.gov/api> and use that to request data from the USDA QuickStats API. In this example, the API key is stored as a `"USDA_KEY"` environment variable.


```r
library(tidyUSDA)

usda_key <- Sys.getenv("USDA_KEY")
```

Now, let's see which US counties produce have the most acres devoted to cucumbers. To use the `getQuickstat()` function effectively, it is helpful to construct a query first at <https://quickstats.nass.usda.gov/> and see what options are available, then bring those options as arguments into R.


```r
cucumbers <- getQuickstat(
  key = usda_key,
  program = "CENSUS",
  data_item = "CUCUMBERS, FRESH MARKET - ACRES HARVESTED",
  sector = "CROPS",
  group = "VEGETABLES",
  commodity = "CUCUMBERS",
  category = "AREA HARVESTED",
  domain = "TOTAL",
  geographic_level = "COUNTY",
  year = "2017"
)
```

This information allows us to look at the top cucumber-growing counties in the US:


```r
cucumbers %>%
  select(state_name, county_name, Value) %>%
  arrange(desc(Value))
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:show-top-cucumbers)Top cucumber-growing counties in the United States</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> state_name </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> county_name </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> FLORIDA </td>
   <td style="text-align:left;"> MANATEE </td>
   <td style="text-align:right;"> 2162 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MICHIGAN </td>
   <td style="text-align:left;"> BERRIEN </td>
   <td style="text-align:right;"> 1687 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CALIFORNIA </td>
   <td style="text-align:left;"> SAN JOAQUIN </td>
   <td style="text-align:right;"> 1558 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GEORGIA </td>
   <td style="text-align:left;"> BROOKS </td>
   <td style="text-align:right;"> 1495 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NORTH CAROLINA </td>
   <td style="text-align:left;"> SAMPSON </td>
   <td style="text-align:right;"> 1299 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FLORIDA </td>
   <td style="text-align:left;"> HILLSBOROUGH </td>
   <td style="text-align:right;"> 1070 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MICHIGAN </td>
   <td style="text-align:left;"> BAY </td>
   <td style="text-align:right;"> 453 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NEW JERSEY </td>
   <td style="text-align:left;"> GLOUCESTER </td>
   <td style="text-align:right;"> 438 </td>
  </tr>
</tbody>
</table>

## Getting government data without R packages

The breath of R's developer ecosystem means that in many cases if you have a need for US government data, an enterprising developer has written some code that you can use. However, this won't be true for every data resource, especially as US government agencies continue to release new API endpoints to open up access to data. In this case, you may be interested in writing your own data access functions for this purpose. This section gives some pointers on how to make HTTP requests to data APIs using the httr package and process the data appropriately for use in R.

### Making requests to APIs with httr

Most data API packages in R will rely on the **httr** R package [@wickham_httr], which provides R functions for common HTTP requests such as `GET`, `POST`, and `PUT`, among others. In this example, we'll use the `httr::GET()` function to make a request to the new [Department of Housing and Urban Development Comprehensive Affordable Housing Strategy (CHAS) API](https://www.huduser.gov/portal/dataset/chas-api.html). This will require getting a HUD API token and storing it as an environment variable as described earlier in this chapter.

Every API will be structured differently with respect to how it accepts queries and authenticates with API tokens. In this example, the documentation instructs users to pass the API token in the HTTP request with the `Authentication: Bearer` header. The example URL in the documentation, [`https://www.huduser.gov/hudapi/public/chas?type=3&year=2012-2016&stateId=51&entityId=59`](https://www.huduser.gov/hudapi/public/chas?type=3&year=2012-2016&stateId=51&entityId=59), is passed to `GET()`, and the `add_headers()` function in httr is used to assemble an appropriate string to send to the API.


```r
library(glue)
library(httr)
library(jsonlite)
library(tidyverse)

my_token <- Sys.getenv("HUD_TOKEN")

hud_chas_request <- GET("https://www.huduser.gov/hudapi/public/chas?type=3&year=2012-2016&stateId=51&entityId=59",
                        add_headers(Authorization = glue("Bearer {my_token}")))

hud_chas_request$status_code
```

```
## [1] 200
```

As we got back the HTTP status code 200, we know that our request to the API succeeded. To view the returned data, we use the `content()` function and translate the result to text with the `as = "text"` argument.


```r
content(hud_chas_request, as = "text")
```

```
## [1] "[{\"geoname\":\"Fairfax County, Virginia\",\"sumlevel\":\"County\",\"year\":\"2012-2016\",\"A1\":\"12895.0\",\"A2\":\"21805.0\",\"A3\":\"34700.0\",\"A4\":\"14165.0\",\"A5\":\"17535.0\",\"A6\":\"31700.0\",\"A7\":\"10690.0\",\"A8\":\"10350.0\",\"A9\":\"21040.0\",\"A10\":\"16890.0\",\"A11\":\"14325.0\",\"A12\":\"31215.0\",\"A13\":\"210710.0\",\"A14\":\"63990.0\",\"A15\":\"274700.0\",\"A16\":\"265350.0\",\"A17\":\"128005.0\",\"A18\":\"393360.0\",\"B1\":\"58925.0\",\"B2\":\"57735.0\",\"B3\":\"116660.0\",\"B4\":\"205390.0\",\"B5\":\"68400.0\",\"B6\":\"273790.0\",\"B7\":\"1035.0\",\"B8\":\"1875.0\",\"B9\":\"2910.0\",\"C1\":\"23945.0\",\"C2\":\"31650.0\",\"C3\":\"55595.0\",\"C4\":\"240370.0\",\"C5\":\"94480.0\",\"C6\":\"334850.0\",\"D1\":\"207915.0\",\"D2\":\"73630.0\",\"D3\":\"281545.0\",\"D4\":\"35735.0\",\"D5\":\"28910.0\",\"D6\":\"64645.0\",\"D7\":\"20670.0\",\"D8\":\"23405.0\",\"D9\":\"44075.0\",\"D10\":\"1035.0\",\"D11\":\"2060.0\",\"D12\":\"3095.0\",\"E1\":\"28030.0\",\"E2\":\"3760.0\",\"E3\":\"2910.0\",\"E5\":\"25945.0\",\"E6\":\"5755.0\",\"E7\":\"0.0\",\"E9\":\"14305.0\",\"E10\":\"6735.0\",\"E11\":\"0.0\",\"E13\":\"16085.0\",\"E14\":\"15135.0\",\"E15\":\"0.0\",\"E17\":\"32295.0\",\"E18\":\"242405.0\",\"E19\":\"0.0\",\"E21\":\"116660.0\",\"E22\":\"273790.0\",\"E23\":\"2910.0\",\"F1\":\"17265.0\",\"F2\":\"2665.0\",\"F3\":\"1875.0\",\"F5\":\"15720.0\",\"F6\":\"1815.0\",\"F7\":\"0.0\",\"F9\":\"8165.0\",\"F10\":\"2185.0\",\"F11\":\"0.0\",\"F13\":\"7900.0\",\"F14\":\"6430.0\",\"F15\":\"0.0\",\"F17\":\"8685.0\",\"F18\":\"55305.0\",\"F19\":\"0.0\",\"F21\":\"57735.0\",\"F22\":\"68400.0\",\"F23\":\"1875.0\",\"G1\":\"10765.0\",\"G2\":\"1095.0\",\"G3\":\"1035.0\",\"G5\":\"10225.0\",\"G6\":\"3940.0\",\"G7\":\"0.0\",\"G9\":\"6140.0\",\"G10\":\"4550.0\",\"G11\":\"0.0\",\"G13\":\"8185.0\",\"G14\":\"8705.0\",\"G15\":\"0.0\",\"G17\":\"23610.0\",\"G18\":\"187100.0\",\"G19\":\"0.0\",\"H1\":\"27605.0\",\"H2\":\"23420.0\",\"H4\":\"24970.0\",\"H5\":\"12660.0\",\"H7\":\"13465.0\",\"H8\":\"3470.0\",\"H10\":\"14930.0\",\"H11\":\"2060.0\",\"H13\":\"27750.0\",\"H14\":\"2460.0\",\"H16\":\"108720.0\",\"I1\":\"16895.0\",\"I2\":\"14490.0\",\"I4\":\"14970.0\",\"I5\":\"7115.0\",\"I7\":\"7550.0\",\"I8\":\"1180.0\",\"I10\":\"7000.0\",\"I11\":\"425.0\",\"I13\":\"5900.0\",\"I14\":\"195.0\",\"I16\":\"52315.0\",\"J1\":\"10705.0\",\"J2\":\"8930.0\",\"J4\":\"10005.0\",\"J5\":\"5550.0\",\"J7\":\"5915.0\",\"J8\":\"2290.0\",\"J10\":\"7930.0\",\"J11\":\"1635.0\",\"J13\":\"21850.0\",\"J14\":\"2265.0\",\"J16\":\"56405.0\"}]"
```

The data were returned as [JavaScript Object Notation, or JSON](https://www.json.org/json-en.html), a very common data format for returning data from APIs. While the data shown above is moderately interpretable, it will require some additional translation for use in R. The **jsonlite** package [@ooms2014] includes a poewrful set of tools for working with JSON objects in R; here, we'll use the `fromJSON()` function to convert JSON to a data frame.


```r
hud_chas_request %>%
  content(as = "text") %>%
  fromJSON()
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:hud-from-json-styling)CHAS API request as a data frame</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> geoname </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> sumlevel </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> year </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A1 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A2 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A3 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A4 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A5 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A6 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A7 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A8 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A9 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A10 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A11 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A12 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A13 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A14 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A15 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A16 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A17 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> A18 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> B1 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> B2 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> B3 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> B4 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> B5 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> B6 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> B7 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> B8 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> B9 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> C1 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> C2 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> C3 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> C4 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> C5 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> C6 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> D1 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> D2 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> D3 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> D4 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> D5 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> D6 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> D7 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> D8 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> D9 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> D10 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> D11 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> D12 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E1 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E2 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E3 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E5 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E6 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E7 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E9 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E10 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E11 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E13 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E14 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E15 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E17 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E18 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E19 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E21 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E22 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> E23 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F1 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F2 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F3 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F5 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F6 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F7 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F9 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F10 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F11 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F13 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F14 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F15 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F17 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F18 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F19 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F21 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F22 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> F23 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> G1 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> G2 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> G3 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> G5 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> G6 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> G7 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> G9 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> G10 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> G11 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> G13 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> G14 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> G15 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> G17 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> G18 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> G19 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> H1 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> H2 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> H4 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> H5 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> H7 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> H8 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> H10 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> H11 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> H13 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> H14 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> H16 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> I1 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> I2 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> I4 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> I5 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> I7 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> I8 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> I10 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> I11 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> I13 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> I14 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> I16 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> J1 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> J2 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> J4 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> J5 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> J7 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> J8 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> J10 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> J11 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> J13 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> J14 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> J16 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Fairfax County, Virginia </td>
   <td style="text-align:left;"> County </td>
   <td style="text-align:left;"> 2012-2016 </td>
   <td style="text-align:left;"> 12895.0 </td>
   <td style="text-align:left;"> 21805.0 </td>
   <td style="text-align:left;"> 34700.0 </td>
   <td style="text-align:left;"> 14165.0 </td>
   <td style="text-align:left;"> 17535.0 </td>
   <td style="text-align:left;"> 31700.0 </td>
   <td style="text-align:left;"> 10690.0 </td>
   <td style="text-align:left;"> 10350.0 </td>
   <td style="text-align:left;"> 21040.0 </td>
   <td style="text-align:left;"> 16890.0 </td>
   <td style="text-align:left;"> 14325.0 </td>
   <td style="text-align:left;"> 31215.0 </td>
   <td style="text-align:left;"> 210710.0 </td>
   <td style="text-align:left;"> 63990.0 </td>
   <td style="text-align:left;"> 274700.0 </td>
   <td style="text-align:left;"> 265350.0 </td>
   <td style="text-align:left;"> 128005.0 </td>
   <td style="text-align:left;"> 393360.0 </td>
   <td style="text-align:left;"> 58925.0 </td>
   <td style="text-align:left;"> 57735.0 </td>
   <td style="text-align:left;"> 116660.0 </td>
   <td style="text-align:left;"> 205390.0 </td>
   <td style="text-align:left;"> 68400.0 </td>
   <td style="text-align:left;"> 273790.0 </td>
   <td style="text-align:left;"> 1035.0 </td>
   <td style="text-align:left;"> 1875.0 </td>
   <td style="text-align:left;"> 2910.0 </td>
   <td style="text-align:left;"> 23945.0 </td>
   <td style="text-align:left;"> 31650.0 </td>
   <td style="text-align:left;"> 55595.0 </td>
   <td style="text-align:left;"> 240370.0 </td>
   <td style="text-align:left;"> 94480.0 </td>
   <td style="text-align:left;"> 334850.0 </td>
   <td style="text-align:left;"> 207915.0 </td>
   <td style="text-align:left;"> 73630.0 </td>
   <td style="text-align:left;"> 281545.0 </td>
   <td style="text-align:left;"> 35735.0 </td>
   <td style="text-align:left;"> 28910.0 </td>
   <td style="text-align:left;"> 64645.0 </td>
   <td style="text-align:left;"> 20670.0 </td>
   <td style="text-align:left;"> 23405.0 </td>
   <td style="text-align:left;"> 44075.0 </td>
   <td style="text-align:left;"> 1035.0 </td>
   <td style="text-align:left;"> 2060.0 </td>
   <td style="text-align:left;"> 3095.0 </td>
   <td style="text-align:left;"> 28030.0 </td>
   <td style="text-align:left;"> 3760.0 </td>
   <td style="text-align:left;"> 2910.0 </td>
   <td style="text-align:left;"> 25945.0 </td>
   <td style="text-align:left;"> 5755.0 </td>
   <td style="text-align:left;"> 0.0 </td>
   <td style="text-align:left;"> 14305.0 </td>
   <td style="text-align:left;"> 6735.0 </td>
   <td style="text-align:left;"> 0.0 </td>
   <td style="text-align:left;"> 16085.0 </td>
   <td style="text-align:left;"> 15135.0 </td>
   <td style="text-align:left;"> 0.0 </td>
   <td style="text-align:left;"> 32295.0 </td>
   <td style="text-align:left;"> 242405.0 </td>
   <td style="text-align:left;"> 0.0 </td>
   <td style="text-align:left;"> 116660.0 </td>
   <td style="text-align:left;"> 273790.0 </td>
   <td style="text-align:left;"> 2910.0 </td>
   <td style="text-align:left;"> 17265.0 </td>
   <td style="text-align:left;"> 2665.0 </td>
   <td style="text-align:left;"> 1875.0 </td>
   <td style="text-align:left;"> 15720.0 </td>
   <td style="text-align:left;"> 1815.0 </td>
   <td style="text-align:left;"> 0.0 </td>
   <td style="text-align:left;"> 8165.0 </td>
   <td style="text-align:left;"> 2185.0 </td>
   <td style="text-align:left;"> 0.0 </td>
   <td style="text-align:left;"> 7900.0 </td>
   <td style="text-align:left;"> 6430.0 </td>
   <td style="text-align:left;"> 0.0 </td>
   <td style="text-align:left;"> 8685.0 </td>
   <td style="text-align:left;"> 55305.0 </td>
   <td style="text-align:left;"> 0.0 </td>
   <td style="text-align:left;"> 57735.0 </td>
   <td style="text-align:left;"> 68400.0 </td>
   <td style="text-align:left;"> 1875.0 </td>
   <td style="text-align:left;"> 10765.0 </td>
   <td style="text-align:left;"> 1095.0 </td>
   <td style="text-align:left;"> 1035.0 </td>
   <td style="text-align:left;"> 10225.0 </td>
   <td style="text-align:left;"> 3940.0 </td>
   <td style="text-align:left;"> 0.0 </td>
   <td style="text-align:left;"> 6140.0 </td>
   <td style="text-align:left;"> 4550.0 </td>
   <td style="text-align:left;"> 0.0 </td>
   <td style="text-align:left;"> 8185.0 </td>
   <td style="text-align:left;"> 8705.0 </td>
   <td style="text-align:left;"> 0.0 </td>
   <td style="text-align:left;"> 23610.0 </td>
   <td style="text-align:left;"> 187100.0 </td>
   <td style="text-align:left;"> 0.0 </td>
   <td style="text-align:left;"> 27605.0 </td>
   <td style="text-align:left;"> 23420.0 </td>
   <td style="text-align:left;"> 24970.0 </td>
   <td style="text-align:left;"> 12660.0 </td>
   <td style="text-align:left;"> 13465.0 </td>
   <td style="text-align:left;"> 3470.0 </td>
   <td style="text-align:left;"> 14930.0 </td>
   <td style="text-align:left;"> 2060.0 </td>
   <td style="text-align:left;"> 27750.0 </td>
   <td style="text-align:left;"> 2460.0 </td>
   <td style="text-align:left;"> 108720.0 </td>
   <td style="text-align:left;"> 16895.0 </td>
   <td style="text-align:left;"> 14490.0 </td>
   <td style="text-align:left;"> 14970.0 </td>
   <td style="text-align:left;"> 7115.0 </td>
   <td style="text-align:left;"> 7550.0 </td>
   <td style="text-align:left;"> 1180.0 </td>
   <td style="text-align:left;"> 7000.0 </td>
   <td style="text-align:left;"> 425.0 </td>
   <td style="text-align:left;"> 5900.0 </td>
   <td style="text-align:left;"> 195.0 </td>
   <td style="text-align:left;"> 52315.0 </td>
   <td style="text-align:left;"> 10705.0 </td>
   <td style="text-align:left;"> 8930.0 </td>
   <td style="text-align:left;"> 10005.0 </td>
   <td style="text-align:left;"> 5550.0 </td>
   <td style="text-align:left;"> 5915.0 </td>
   <td style="text-align:left;"> 2290.0 </td>
   <td style="text-align:left;"> 7930.0 </td>
   <td style="text-align:left;"> 1635.0 </td>
   <td style="text-align:left;"> 21850.0 </td>
   <td style="text-align:left;"> 2265.0 </td>
   <td style="text-align:left;"> 56405.0 </td>
  </tr>
</tbody>
</table>

The data are now formatted as an R data frame which can be embedded in your R-based workflows.

### Writing your own data access functions

If you plan to use a particular API endpoint frequently, or for different areas and times, it is a good idea to write a data access function. API functions should ideally identify the components of the API request that can vary, and allow users to make modifications in ways that correspond to those components.

The URL used in the example above can be separated into two components: the *API endpoint* [`https://www.huduser.gov/hudapi/public/chas`](https://www.huduser.gov/hudapi/public/chas), which will be common to all API requests, and the *query* `?type=3&year=2012-2016&stateId=51&entityId=59`, which shows components of the request that can vary. The query will generally follow a question mark sign and be composed of key-value pairs, e.g. `type=3`, which in this example means county according to the HUD API documentation. These queries can be passed as a list to the `query` parameter of `GET()` and formatted appropriately in the HTTP request by **httr**.

The function below is an example you can use to get started writing your own API data request functions. The general components of the function are as follows:

-   The function is defined by a name, `get_hud_chas()`, with a number of parameters to which the user will supply arguments. Default arguments can be specified (e.g. `year = "2013-2017"` to request that data without the user needing to specify it directly. If a default argument is `NULL`, it will be ignored by the `GET()` request.

-   The function first checks to see if an existing HUD token exists in the user's environment referenced by the name `HUD_TOKEN` if the user hasn't supplied it directly.

-   Next, the function constructs the `GET()` query, translating the function arguments to an HTTP query.

-   If the request has failed, the function returns the error message from the API to help inform the user about what went wrong.

-   If the request succeeds, the function converts the result to text, then the JSON to a data frame which will be pivoted to long form using **tidyr**'s `pivot_longer()` function. Finally, the result is returned. I use the `return()` function here, which isn't strictly necessary but I use it because it is helpful for me to see where the function exits in my code.

-   You may notice a couple new notational differences from code used elsewhere in this book. Functions are referenced with the `packagename::function()` notation, and the new base R pipe `|>` is used instead of the magrittr pipe `%>%`. This allows the function to run without loading any external libraries with `library()`, which is generally a good idea when writing functions to avoid namespace conflicts.


```r
get_hud_chas <- function(
  type, 
  year = "2013-2017", 
  state_id = NULL, 
  entity_id = NULL, 
  token = NULL
) {
  
  # Check to see if a token exists
  if (is.null(token)) {
    if (Sys.getenv("HUD_TOKEN") != "") {
      token <- Sys.getenv("HUD_TOKEN")
    }
  }
  
  # Specify the base URL
  base_url <- "https://www.huduser.gov/hudapi/public/chas"
  
  # Make the query
  hud_query <- httr::GET(
    base_url,
    httr::add_headers(Authorization = glue::glue("Bearer {token}")),
    query = list(
      type = type,
      year = year,
      stateId = state_id,
      entityId = entity_id)
  )
  
  # Return the HTTP error message if query failed
  if (hud_query$status_code != "200") {
    msg <- httr::content(hud_query, as = "text")
    return(msg)
  }
  
  # Return the content as text
  hud_content <- httr::content(hud_query, as = "text")
  
  # Convert the data to a long-form tibble
  hud_tibble <- hud_content |>
    jsonlite::fromJSON() |>
    dplyr::as_tibble() |>
    tidyr::pivot_longer(cols = !dplyr::all_of(c("geoname", "sumlevel", "year")),
                        names_to = "indicator",
                        values_to = "value")
  
  return(hud_tibble)
  
}
```

Now, let's try out the function for a different locality in Virginia:


```r
get_hud_chas(type = 3, state_id = 51, entity_id = 510)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:show-use-function)Affordable housing data for Alexandria, Virginia using a custom-built API function</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> geoname </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> sumlevel </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> year </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> indicator </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Alexandria city, Virginia </td>
   <td style="text-align:left;"> County </td>
   <td style="text-align:left;"> 2013-2017 </td>
   <td style="text-align:left;"> A1 </td>
   <td style="text-align:left;"> 1185.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alexandria city, Virginia </td>
   <td style="text-align:left;"> County </td>
   <td style="text-align:left;"> 2013-2017 </td>
   <td style="text-align:left;"> A2 </td>
   <td style="text-align:left;"> 6745.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alexandria city, Virginia </td>
   <td style="text-align:left;"> County </td>
   <td style="text-align:left;"> 2013-2017 </td>
   <td style="text-align:left;"> A3 </td>
   <td style="text-align:left;"> 7930.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alexandria city, Virginia </td>
   <td style="text-align:left;"> County </td>
   <td style="text-align:left;"> 2013-2017 </td>
   <td style="text-align:left;"> A4 </td>
   <td style="text-align:left;"> 1335.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alexandria city, Virginia </td>
   <td style="text-align:left;"> County </td>
   <td style="text-align:left;"> 2013-2017 </td>
   <td style="text-align:left;"> A5 </td>
   <td style="text-align:left;"> 5355.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alexandria city, Virginia </td>
   <td style="text-align:left;"> County </td>
   <td style="text-align:left;"> 2013-2017 </td>
   <td style="text-align:left;"> A6 </td>
   <td style="text-align:left;"> 6690.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alexandria city, Virginia </td>
   <td style="text-align:left;"> County </td>
   <td style="text-align:left;"> 2013-2017 </td>
   <td style="text-align:left;"> A7 </td>
   <td style="text-align:left;"> 1245.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alexandria city, Virginia </td>
   <td style="text-align:left;"> County </td>
   <td style="text-align:left;"> 2013-2017 </td>
   <td style="text-align:left;"> A8 </td>
   <td style="text-align:left;"> 3580.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alexandria city, Virginia </td>
   <td style="text-align:left;"> County </td>
   <td style="text-align:left;"> 2013-2017 </td>
   <td style="text-align:left;"> A9 </td>
   <td style="text-align:left;"> 4825.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alexandria city, Virginia </td>
   <td style="text-align:left;"> County </td>
   <td style="text-align:left;"> 2013-2017 </td>
   <td style="text-align:left;"> A10 </td>
   <td style="text-align:left;"> 1465.0 </td>
  </tr>
</tbody>
</table>

The function returns affordable data for Alexandria, Virginia in a format that is more suitable for use with tidyverse tools.

## Exercises

-   Visit <https://ipums.org> and spend some time exploring NHGIS and/or IPUMS. Attempt to replicate the NHGIS workflow for a different variable and time period.

-   Explore the **censusapi** package and create a request to a Census API endpoint using the package that you weren't previously familiar with. Join the data to shapes you've obtained with **tigris** and make a map of your data.
