# An introduction to tidycensus



The **tidycensus** package [@walker_and_herman2021], first released in 2017, is an R package designed to facilitate the process of acquiring and working with US Census Bureau population data in the R environment. The package has two distinct goals. First, **tidycensus** aims to make Census data available to R users in a **tidyverse**-friendly format, helping kick-start the process of generating insights from US Census data. Second, the package is designed to streamline the data wrangling process for spatial Census data analysts. With **tidycensus**, R users can request *geometry* along with attributes for their Census data, helping facilitate mapping and spatial analysis. This functionality of **tidycensus** is covered in more depth in Chapters \@ref(mapping-census-data-with-r), \@ref(spatial-analysis-with-us-census-data), and \@ref(modeling-us-census-data).

As discussed in the previous chapter, the US Census Bureau makes a wide range of datasets available to the user community through their APIs and other data download resources. **tidycensus** is not a comprehensive portal to these data resources; instead, it focuses on a select number of datasets implemented in a series of core functions. These core functions in **tidycensus** include:

-   `get_decennial()`, which requests data from the US Decennial Census APIs for 2000 and 2010. When 2020 Census data are released via the API, R users will be able to access it with this function as well.

-   `get_acs()`, which requests data from the 1-year and 5-year American Community Survey samples. Data are available from the 1-year ACS back to 2005 and the 5-year ACS back to 2005-2009.

-   `get_estimates()`, an interface to the Population Estimates APIs. These datasets include yearly estimates of population characteristics by state, county, and metropolitan area, along with components of change demographic estimates like births, deaths, and migration rates.

-   `get_pums()`, which accesses data from the ACS Public Use Microdata Sample APIs. These samples include anonymized individual-level records from the ACS organized by household and are highly useful for many different social science analyses. `get_pums()` is covered in more depth in Chapters \@ref(introduction-to-census-microdata) and \@ref(analyzing-census-microdata).

-   `get_flows()`, an interface to the ACS Migration Flows APIs. Includes information on in- and out-flows from various geographies for the 5-year ACS samples, enabling origin-destination analyses.

## Getting started with tidycensus

To get started with **tidycensus**, users should install the package with `install.packages("tidycensus")` if not yet installed; load the package with `library("tidycensus")`; and set their Census API key with the `census_api_key()` function. API keys can be obtained at <https://api.census.gov/data/key_signup.html>. After you've signed up for an API key, be sure to activate the key from the email you receive from the Census Bureau so it works correctly. Declaring `install = TRUE` when calling `census_api_key()` will install the key for use in future R sessions, which may be convenient for many users.


```r
library(tidycensus)
# census_api_key("YOUR KEY GOES HERE", install = TRUE)
```

### Decennial Census

Once an API key is installed, users can obtain decennial Census or ACS data with a single function call. Let's start with `get_decennial()`, which is used to access decennial Census data from the 2000 and 2010 Censuses.

::: {.rmdnote}
At the time of this writing, 2020 decennial Census data are not yet available from the Census API. When the 2020 redistricting files are released to the API (currently scheduled for September 30), **tidycensus** will support them and this section of the book will be updated. Until then, the [PL94171 package](https://corymccartan.github.io/PL94171/) is the best way to work with the raw 2020 redistricting files from the Census Bureau.
:::

To get data from the decennial US Census, users must specify a string representing the requested `geography`; a vector of Census variable IDs, represented by `variable`; or optionally a Census table ID, passed to `table`. The code below gets data on total population by state from the 2010 decennial Census.


```r
total_population_10 <- get_decennial(
  geography = "state", 
  variables = "P001001",
  year = 2010
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:total-population-10-show)Total population by state, 2010 Census</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> P001001 </td>
   <td style="text-align:right;"> 4779736 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 02 </td>
   <td style="text-align:left;"> Alaska </td>
   <td style="text-align:left;"> P001001 </td>
   <td style="text-align:right;"> 710231 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04 </td>
   <td style="text-align:left;"> Arizona </td>
   <td style="text-align:left;"> P001001 </td>
   <td style="text-align:right;"> 6392017 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 05 </td>
   <td style="text-align:left;"> Arkansas </td>
   <td style="text-align:left;"> P001001 </td>
   <td style="text-align:right;"> 2915918 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 06 </td>
   <td style="text-align:left;"> California </td>
   <td style="text-align:left;"> P001001 </td>
   <td style="text-align:right;"> 37253956 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 22 </td>
   <td style="text-align:left;"> Louisiana </td>
   <td style="text-align:left;"> P001001 </td>
   <td style="text-align:right;"> 4533372 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 21 </td>
   <td style="text-align:left;"> Kentucky </td>
   <td style="text-align:left;"> P001001 </td>
   <td style="text-align:right;"> 4339367 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 08 </td>
   <td style="text-align:left;"> Colorado </td>
   <td style="text-align:left;"> P001001 </td>
   <td style="text-align:right;"> 5029196 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 09 </td>
   <td style="text-align:left;"> Connecticut </td>
   <td style="text-align:left;"> P001001 </td>
   <td style="text-align:right;"> 3574097 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> Delaware </td>
   <td style="text-align:left;"> P001001 </td>
   <td style="text-align:right;"> 897934 </td>
  </tr>
</tbody>
</table>

The function returns a tibble of data from the 2010 US Census (the function default year) with information on total population by state, and assigns it to the object `total_population_10`. Data for 2000 can also be obtained by supplying the appropriate year to the `year` parameter.

### American Community Survey

Similarly, `get_acs()` retrieves data from the American Community Survey. As discussed in the previous chapter, the ACS includes a wide variety of variables detailing characteristics of the US population not found in the decennial Census. The example below fetches data on the number of residents born in Mexico by state.


```r
born_in_mexico <- get_acs(
  geography = "state", 
  variables = "B05006_150",
  year = 2019
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:acs-5-year-show)Mexican-born population by state, 2015-2019 5-year ACS</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> estimate </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> moe </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> 49052 </td>
   <td style="text-align:right;"> 2202 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 02 </td>
   <td style="text-align:left;"> Alaska </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> 4528 </td>
   <td style="text-align:right;"> 798 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04 </td>
   <td style="text-align:left;"> Arizona </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> 511861 </td>
   <td style="text-align:right;"> 7420 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 05 </td>
   <td style="text-align:left;"> Arkansas </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> 59271 </td>
   <td style="text-align:right;"> 2101 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 06 </td>
   <td style="text-align:left;"> California </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> 4076121 </td>
   <td style="text-align:right;"> 23048 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 08 </td>
   <td style="text-align:left;"> Colorado </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> 225372 </td>
   <td style="text-align:right;"> 4757 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 09 </td>
   <td style="text-align:left;"> Connecticut </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> 27399 </td>
   <td style="text-align:right;"> 2056 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> Delaware </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> 16663 </td>
   <td style="text-align:right;"> 1145 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> District of Columbia </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> 4022 </td>
   <td style="text-align:right;"> 856 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> Florida </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> 266547 </td>
   <td style="text-align:right;"> 6349 </td>
  </tr>
</tbody>
</table>

If the year is not specified, `get_acs()` defaults to the most recent five-year ACS sample, which at the time of this writing is 2015-2019. The data returned is similar in structure to that returned by `get_decennial()`, but includes an `estimate` column (for the ACS estimate) and `moe` column (for the margin of error around that estimate) instead of a `value` column. Different years and different surveys are available by adjusting the `year` and `survey` parameters. `survey` defaults to the 5-year ACS; however this can be changed to the 1-year ACS by using the argument `survey = "acs1"`. For example, the following code will fetch data from the 1-year ACS for 2019:


```r
born_in_mexico_1yr <- get_acs(
  geography = "state", 
  variables = "B05006_150", 
  survey = "acs1",
  year = 2019
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:acs-1yr-show)Mexican-born population by state, 2019 1-year ACS</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> estimate </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> moe </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 02 </td>
   <td style="text-align:left;"> Alaska </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04 </td>
   <td style="text-align:left;"> Arizona </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> 516618 </td>
   <td style="text-align:right;"> 15863 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 05 </td>
   <td style="text-align:left;"> Arkansas </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 06 </td>
   <td style="text-align:left;"> California </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> 3951224 </td>
   <td style="text-align:right;"> 40506 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 08 </td>
   <td style="text-align:left;"> Colorado </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> 209408 </td>
   <td style="text-align:right;"> 12214 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 09 </td>
   <td style="text-align:left;"> Connecticut </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> 26371 </td>
   <td style="text-align:right;"> 4816 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> Delaware </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> District of Columbia </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 12 </td>
   <td style="text-align:left;"> Florida </td>
   <td style="text-align:left;"> B05006_150 </td>
   <td style="text-align:right;"> 261614 </td>
   <td style="text-align:right;"> 17571 </td>
  </tr>
</tbody>
</table>

Note the differences between the 5-year ACS estimates and the 1-year ACS estimates shown. For states with larger Mexican-born populations like Arizona, California, and Colorado, the 1-year ACS data will represent the most up-to-date estimates, albeit characterized by larger margins of error relative to their estimates. For states with smaller Mexican-born populations like Alabama, Alaska, and Arkansas, however, the estimate returns `NA`, R's notation representing missing data. If you encounter this in your data's `estimate` column, it will generally mean that the estimate is too small for a given geography to be deemed reliable by the Census Bureau. In this case, only the states with the largest Mexican-born populations have data available for that variable in the 1-year ACS, meaning that the 5-year ACS should be used to make full state-wise comparisons if desired.

Variables from the ACS detailed tables, data profiles, summary tables, and supplemental estimates are available through **tidycensus**'s `get_acs()` function; the function will auto-detect from which dataset to look for variables based on their names. Alternatively, users can supply a table name to the `table` parameter in `get_acs()`; this will return data for every variable in that table. For example, to get all variables associated with table B01001, which covers sex broken down by age, from the 2015-2019 5-year ACS:


```r
age_table <- get_acs(
  geography = "state", 
  table = "B01001",
  year = 2019
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:state-age-table-show)Table B01001 by state from the 2015-2019 5-year ACS</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> estimate </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> moe </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01001_001 </td>
   <td style="text-align:right;"> 4876250 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01001_002 </td>
   <td style="text-align:right;"> 2359355 </td>
   <td style="text-align:right;"> 1270 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01001_003 </td>
   <td style="text-align:right;"> 149090 </td>
   <td style="text-align:right;"> 704 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01001_004 </td>
   <td style="text-align:right;"> 153494 </td>
   <td style="text-align:right;"> 2290 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01001_005 </td>
   <td style="text-align:right;"> 158617 </td>
   <td style="text-align:right;"> 2274 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01001_006 </td>
   <td style="text-align:right;"> 98257 </td>
   <td style="text-align:right;"> 468 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01001_007 </td>
   <td style="text-align:right;"> 64980 </td>
   <td style="text-align:right;"> 834 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01001_008 </td>
   <td style="text-align:right;"> 35870 </td>
   <td style="text-align:right;"> 1436 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01001_009 </td>
   <td style="text-align:right;"> 35040 </td>
   <td style="text-align:right;"> 1472 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01001_010 </td>
   <td style="text-align:right;"> 95065 </td>
   <td style="text-align:right;"> 1916 </td>
  </tr>
</tbody>
</table>

To find all of the variables associated with a given ACS table, **tidycensus** downloads a dataset of variables from the Census Bureau website and looks up the variable codes for download. If the `cache_table` parameter is set to `TRUE`, the function instructs **tidycensus** to cache this dataset on the user's computer for faster future access. This only needs to be done once per ACS or Census dataset if the user would like to specify this option.

## Geography and variables in tidycensus

The `geography` parameter in `get_acs()` and `get_decennial()` allows users to request data aggregated to common Census enumeration units. At the time of this writing, **tidycensus** accepts enumeration units nested within states and/or counties, when applicable. Census blocks are available in `get_decennial()` but not in `get_acs()` as block-level data are not available from the American Community Survey. To request data within states and/or counties, state and county names can be supplied to the `state` and `county` parameters, respectively. Arguments should be formatted in the way that they are accepted by the US Census Bureau API, specified in the table below. If an "Available by" geography is in bold, that argument is required for that geography.

The only geographies available in 2000 are `"state"`, `"county"`, `"county subdivision"`, `"tract"`, `"block group"`, and `"place"`. Some geographies available from the Census API are not available in tidycensus at the moment as they require more complex hierarchy specification than the package supports, and not all variables are available at every geography.

| Geography                                                                            | Definition                                                                        | Available by          | Available in                                                     |
|--------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------|-----------------------|------------------------------------------------------------------|
| `"us"`                                                                               | United States                                                                     |                       | `get_acs()`, `get_decennial()`, `get_estimates()`                |
| `"region"`                                                                           | Census region                                                                     |                       | `get_acs()`, `get_decennial()`, `get_estimates()`                |
| `"division"`                                                                         | Census division                                                                   |                       | `get_acs()`, `get_decennial()`, `get_estimates()`                |
| `"state"`                                                                            | State or equivalent                                                               | state                 | `get_acs()`, `get_decennial()`, `get_estimates()`, `get_flows()` |
| `"county"`                                                                           | County or equivalent                                                              | state, county         | `get_acs()`, `get_decennial()`, `get_estimates()`, `get_flows()` |
| `"county subdivision"`                                                               | County subdivision                                                                | **state**, county     | `get_acs()`, `get_decennial()`, `get_estimates()`, `get_flows()` |
| `"tract"`                                                                            | Census tract                                                                      | **state**, county     | `get_acs()`, `get_decennial()`                                   |
| `"block group"`                                                                      | Census block group                                                                | **state**, county     | `get_acs()` (2013-), `get_decennial()`                           |
| `"block"`                                                                            | Census block                                                                      | **state**, **county** | `get_decennial()`                                                |
| `"place"`                                                                            | Census-designated place                                                           | state                 | `get_acs()`, `get_decennial()`, `get_estimates()`                |
| `"alaska native regional corporation"`                                               | Alaska native regional corporation                                                | state                 | `get_acs()`, `get_decennial()`                                   |
| `"american indian area/alaska native area/hawaiian home land"`                       | Federal and state-recognized American Indian reservations and Hawaiian home lands | state                 | `get_acs()`, `get_decennial()`                                   |
| `"american indian area/alaska native area (reservation or statistical entity only)"` | Only reservations and statistical entities                                        | state                 | `get_acs()`, `get_decennial()`                                   |
| `"american indian area (off-reservation trust land only)/hawaiian home land"`        | Only off-reservation trust lands and Hawaiian home lands                          | state                 | `get_acs()`,                                                     |
| `"metropolitan statistical area/micropolitan statistical area"` OR `"cbsa"`          | Core-based statistical area                                                       | state                 | `get_acs()`, `get_decennial()`, `get_estimates()`, `get_flows()` |
| `"combined statistical area"`                                                        | Combined statistical area                                                         | state                 | `get_acs()`, `get_decennial()`, `get_estimates()`                |
| `"new england city and town area"`                                                   | New England city/town area                                                        | state                 | `get_acs()`, `get_decennial()`                                   |
| `"combined new england city and town area"`                                          | Combined New England area                                                         | state                 | `get_acs()`, `get_decennial()`                                   |
| `"urban area"`                                                                       | Census-defined urbanized areas                                                    |                       | `get_acs()`, `get_decennial()`                                   |
| `"congressional district"`                                                           | Congressional district for the year-appropriate Congress                          | state                 | `get_acs()`, `get_decennial()`                                   |
| `"school district (elementary)"`                                                     | Elementary school district                                                        | **state**             | `get_acs()`, `get_decennial()`                                   |
| `"school district (secondary)"`                                                      | Secondary school district                                                         | **state**             | `get_acs()`, `get_decennial()`                                   |
| `"school district (unified)"`                                                        | Unified school district                                                           | **state**             | `get_acs()`, `get_decennial()`                                   |
| `"public use microdata area"`                                                        | PUMA (geography associated with Census microdata samples)                         | state                 | `get_acs()`                                                      |
| `"zip code tabulation area"` OR `"zcta"`                                             | Zip code tabulation area                                                          | state                 | `get_acs()`, `get_decennial()`                                   |
| `"state legislative district (upper chamber)"`                                       | State senate districts                                                            | **state**             | `get_acs()`, `get_decennial()`                                   |
| `"state legislative district (lower chamber)"`                                       | State house districts                                                             | **state**             | `get_acs()`, `get_decennial()`                                   |

The geography parameter must be typed exactly as specified in the table above to request data correctly from the Census API; use the guide above as a reference and copy-paste for longer strings. For core-based statistical areas and zip code tabulation areas, two heavily-requested geographies, the aliases `"cbsa"` and `"zcta"` can be used, respectively, to fetch data for those geographies.


```r
cbsa_population <- get_acs(
  geography = "cbsa",
  variables = "B01003_001",
  year = 2019
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:cbsa-alias-show)Population by CBSA</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> estimate </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> moe </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 10100 </td>
   <td style="text-align:left;"> Aberdeen, SD Micro Area </td>
   <td style="text-align:left;"> B01003_001 </td>
   <td style="text-align:right;"> 42824 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10140 </td>
   <td style="text-align:left;"> Aberdeen, WA Micro Area </td>
   <td style="text-align:left;"> B01003_001 </td>
   <td style="text-align:right;"> 72779 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10180 </td>
   <td style="text-align:left;"> Abilene, TX Metro Area </td>
   <td style="text-align:left;"> B01003_001 </td>
   <td style="text-align:right;"> 170669 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10220 </td>
   <td style="text-align:left;"> Ada, OK Micro Area </td>
   <td style="text-align:left;"> B01003_001 </td>
   <td style="text-align:right;"> 38355 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10300 </td>
   <td style="text-align:left;"> Adrian, MI Micro Area </td>
   <td style="text-align:left;"> B01003_001 </td>
   <td style="text-align:right;"> 98381 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10380 </td>
   <td style="text-align:left;"> Aguadilla-Isabela, PR Metro Area </td>
   <td style="text-align:left;"> B01003_001 </td>
   <td style="text-align:right;"> 301107 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10420 </td>
   <td style="text-align:left;"> Akron, OH Metro Area </td>
   <td style="text-align:left;"> B01003_001 </td>
   <td style="text-align:right;"> 703845 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10460 </td>
   <td style="text-align:left;"> Alamogordo, NM Micro Area </td>
   <td style="text-align:left;"> B01003_001 </td>
   <td style="text-align:right;"> 66137 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10500 </td>
   <td style="text-align:left;"> Albany, GA Metro Area </td>
   <td style="text-align:left;"> B01003_001 </td>
   <td style="text-align:right;"> 148436 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10540 </td>
   <td style="text-align:left;"> Albany-Lebanon, OR Metro Area </td>
   <td style="text-align:left;"> B01003_001 </td>
   <td style="text-align:right;"> 125048 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
</tbody>
</table>

### Geographic subsets

For many geographies, **tidycensus** supports more granular requests that are subsetted by state or even by county, if supported by the API. This information is found in the "Available by" column in the guide above. If a geographic subset is in bold, it is required; if not, it is optional.

For example, an analyst might be interested in studying variations in household income in the state of Wisconsin. Although the analyst *can* request all counties in the United States, this is not necessary for this specific task. In turn, they can use the `state` parameter to subset the request for a specific state.


```r
wi_income <- get_acs(
  geography = "county", 
  variables = "B19013_001", 
  state = "WI",
  year = 2019
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:wi-income-county-show)Median household income by county in Wisconsin</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> estimate </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> moe </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 55001 </td>
   <td style="text-align:left;"> Adams County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 46369 </td>
   <td style="text-align:right;"> 1834 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55003 </td>
   <td style="text-align:left;"> Ashland County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 42510 </td>
   <td style="text-align:right;"> 2858 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55005 </td>
   <td style="text-align:left;"> Barron County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 52703 </td>
   <td style="text-align:right;"> 2104 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55007 </td>
   <td style="text-align:left;"> Bayfield County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 56096 </td>
   <td style="text-align:right;"> 1877 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55009 </td>
   <td style="text-align:left;"> Brown County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 62340 </td>
   <td style="text-align:right;"> 1112 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55011 </td>
   <td style="text-align:left;"> Buffalo County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 57829 </td>
   <td style="text-align:right;"> 1873 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55013 </td>
   <td style="text-align:left;"> Burnett County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 52672 </td>
   <td style="text-align:right;"> 1388 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55015 </td>
   <td style="text-align:left;"> Calumet County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 75814 </td>
   <td style="text-align:right;"> 2425 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55017 </td>
   <td style="text-align:left;"> Chippewa County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 59742 </td>
   <td style="text-align:right;"> 1759 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55019 </td>
   <td style="text-align:left;"> Clark County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 54012 </td>
   <td style="text-align:right;"> 1223 </td>
  </tr>
</tbody>
</table>

**tidycensus** accepts state names (e.g. `"Wisconsin"`), state postal codes (e.g. `"WI"`), and state FIPS codes (e.g. `"55"`), so an analyst can use what they are most comfortable with.

Smaller geographies like Census tracts can also be subsetted by county. Given that Census tracts nest neatly within counties (and do not cross county boundaries), we can request all Census tracts for a given county by using the optional `county` parameter. Dane County, home to Wisconsin's capital city of Madison, is shown below. Note that the name of the county can be supplied as well as the FIPS code. If a state has two counties with similar names (e.g. "Collin" and "Collingsworth" in Texas) you'll need to spell out the full county string and type `"Collin County"`.


```r
dane_income <- get_acs(
  geography = "tract", 
  variables = "B19013_001", 
  state = "WI", 
  county = "Dane"
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:dane-income-show)Median household income in Dane County by Census tract</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> estimate </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> moe </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 55025000100 </td>
   <td style="text-align:left;"> Census Tract 1, Dane County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 72471 </td>
   <td style="text-align:right;"> 12984 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55025000201 </td>
   <td style="text-align:left;"> Census Tract 2.01, Dane County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 94821 </td>
   <td style="text-align:right;"> 11860 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55025000202 </td>
   <td style="text-align:left;"> Census Tract 2.02, Dane County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 84145 </td>
   <td style="text-align:right;"> 7021 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55025000204 </td>
   <td style="text-align:left;"> Census Tract 2.04, Dane County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 79617 </td>
   <td style="text-align:right;"> 11823 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55025000205 </td>
   <td style="text-align:left;"> Census Tract 2.05, Dane County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 91326 </td>
   <td style="text-align:right;"> 13453 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55025000300 </td>
   <td style="text-align:left;"> Census Tract 3, Dane County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 53778 </td>
   <td style="text-align:right;"> 7593 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55025000401 </td>
   <td style="text-align:left;"> Census Tract 4.01, Dane County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 98178 </td>
   <td style="text-align:right;"> 7330 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55025000402 </td>
   <td style="text-align:left;"> Census Tract 4.02, Dane County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 107440 </td>
   <td style="text-align:right;"> 6585 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55025000405 </td>
   <td style="text-align:left;"> Census Tract 4.05, Dane County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 68911 </td>
   <td style="text-align:right;"> 4141 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 55025000406 </td>
   <td style="text-align:left;"> Census Tract 4.06, Dane County, Wisconsin </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 74489 </td>
   <td style="text-align:right;"> 10451 </td>
  </tr>
</tbody>
</table>

With respect to geography and the American Community Survey, users should be aware that whereas the 5-year ACS covers geographies down to the block group, the 1-year ACS only returns data for geographies of population 65,000 and greater. This means that some geographies (e.g. Census tracts) will never be available in the 1-year ACS, and that other geographies such as counties are only partially available. To illustrate this, we can check the number of rows in the object `wi_income`:


```r
nrow(wi_income)
```

```
## [1] 72
```

There are 72 rows in this dataset, one for each county in Wisconsin. However, if the same data were requested from the 2019 1-year ACS:


```r
wi_income_1yr <- get_acs(
  geography = "county", 
  variables = "B19013_001", 
  state = "WI",
  year = 2019,
  survey = "acs1"
)

nrow(wi_income_1yr)
```

```
## [1] 23
```

There are only 23 rows in this dataset, representing the 23 counties that meet the "total population of 65,000 or greater" threshold required to be included in the 1-year ACS data.

## Searching for variables in tidycensus

One additional challenge when searching for Census variables is understanding variable IDs, which are required to fetch data from the Census and ACS APIs. There are thousands of variables available across the different datasets and summary files. To make searching easier for R users, **tidycensus** offers the `load_variables()` function. This function obtains a dataset of variables from the Census Bureau website and formats it for fast searching, ideally in RStudio.

The function takes two required arguments: `year`, which takes the year or endyear of the Census dataset or ACS sample, and the dataset name - one of `sf1`, `sf3`, `acs1`, or `acs5`. For the ACS datasets, append `/profile` for the Data Profile, and `/summary` for the Summary Tables. As this function requires processing thousands of variables from the Census Bureau which may take a few moments depending on the user's internet connection, the user can specify `cache = TRUE` in the function call to store the data in the user's cache directory for future access. On subsequent calls of the `load_variables()` function, `cache = TRUE` will direct the function to look in the cache directory for the variables rather than the Census website.

`load_variables()` works as follows:


```r
v16 <- load_variables(2016, "acs5", cache = TRUE)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:v16-show)Variables in the 2012-2016 5-year ACS</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> name </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> label </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> concept </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> B00001_001 </td>
   <td style="text-align:left;"> Estimate!!Total </td>
   <td style="text-align:left;"> UNWEIGHTED SAMPLE COUNT OF THE POPULATION </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B00002_001 </td>
   <td style="text-align:left;"> Estimate!!Total </td>
   <td style="text-align:left;"> UNWEIGHTED SAMPLE HOUSING UNITS </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B01001_001 </td>
   <td style="text-align:left;"> Estimate!!Total </td>
   <td style="text-align:left;"> SEX BY AGE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B01001_002 </td>
   <td style="text-align:left;"> Estimate!!Total!!Male </td>
   <td style="text-align:left;"> SEX BY AGE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B01001_003 </td>
   <td style="text-align:left;"> Estimate!!Total!!Male!!Under 5 years </td>
   <td style="text-align:left;"> SEX BY AGE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B01001_004 </td>
   <td style="text-align:left;"> Estimate!!Total!!Male!!5 to 9 years </td>
   <td style="text-align:left;"> SEX BY AGE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B01001_005 </td>
   <td style="text-align:left;"> Estimate!!Total!!Male!!10 to 14 years </td>
   <td style="text-align:left;"> SEX BY AGE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B01001_006 </td>
   <td style="text-align:left;"> Estimate!!Total!!Male!!15 to 17 years </td>
   <td style="text-align:left;"> SEX BY AGE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B01001_007 </td>
   <td style="text-align:left;"> Estimate!!Total!!Male!!18 and 19 years </td>
   <td style="text-align:left;"> SEX BY AGE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B01001_008 </td>
   <td style="text-align:left;"> Estimate!!Total!!Male!!20 years </td>
   <td style="text-align:left;"> SEX BY AGE </td>
  </tr>
</tbody>
</table>

The returned data frame has three columns: `name`, which refers to the Census variable ID; `label`, which is a descriptive data label for the variable; and `concept`, which refers to the topic of the data and often corresponds to a table of Census data. As illustrated above, the data frame can be filtered using tidyverse tools for variable exploration. However, the RStudio integrated development environment includes an interactive data viewer which is ideal for browsing this dataset, and allows for interactive sorting and filtering. The data viewer can be accessed with the `View()` function:


```r
View(v16)
```

<div class="figure">
<img src="img/view.png" alt="Variable viewer in RStudio" width="100%" />
<p class="caption">(\#fig:view-variables-img)Variable viewer in RStudio</p>
</div>

By browsing the table in this way, users can identify the appropriate variable IDs (found in the `name` column) that can be passed to the `variables` parameter in `get_acs()` or `get_decennial()`. Users may note that the raw variable IDs in the ACS, as consumed by the API, require a suffix of `E` or `M`. **tidycensus** does not require this suffix, as it will automatically return both the estimate and margin of error for a given requested variable. Additionally, if users desire an entire table of related variables from the ACS, the user should supply the characters prior to the underscore from a variable ID to the `table` parameter.

## Data structure in tidycensus

Key to the design philosophy of tidycensus is its interpretation of tidy data. Following @wickham2014, "tidy" data are defined as follows:

1.  Each observation forms a row;
2.  Each variable forms a column;
3.  Each observational unit forms a table.

By default, **tidycensus** returns a tibble of ACS or decennial Census data in "tidy" format. For decennial Census data, this will include four columns:

-   `GEOID`, representing the Census ID code that uniquely identifies the geographic unit;

-   `NAME`, which represents a descriptive name of the unit;

-   `variable`, which contains information on the Census variable name corresponding to that row;

-   `value`, which contains the data values for each unit-variable combination. For ACS data, two columns replace the `value` column: `estimate`, which represents the ACS estimate, and `moe`, representing the margin of error around that estimate.

Given the terminology used by the Census Bureau to distinguish data, it is important to provide some clarifications of nomenclature here. Census or ACS *variables*, which are specific series of data available by enumeration unit, are interpreted in tidycensus as *characteristics* of those enumeration units. In turn, rows in datasets returned when `output = "tidy"`, which is the default setting in the `get_acs()` and `get_decennial()` functions, represent data for unique unit-variable combinations. An example of this is illustrated below with income groups by state for the 2016 1-year American Community Survey.


```r
hhinc <- get_acs(
  geography = "state", 
  table = "B19001", 
  survey = "acs1",
  year = 2016
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:state-income-table-show)Household income groups by state, 2016 1-year ACS</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> estimate </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> moe </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B19001_001 </td>
   <td style="text-align:right;"> 1852518 </td>
   <td style="text-align:right;"> 12189 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B19001_002 </td>
   <td style="text-align:right;"> 176641 </td>
   <td style="text-align:right;"> 6328 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B19001_003 </td>
   <td style="text-align:right;"> 120590 </td>
   <td style="text-align:right;"> 5347 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B19001_004 </td>
   <td style="text-align:right;"> 117332 </td>
   <td style="text-align:right;"> 5956 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B19001_005 </td>
   <td style="text-align:right;"> 108912 </td>
   <td style="text-align:right;"> 5308 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B19001_006 </td>
   <td style="text-align:right;"> 102080 </td>
   <td style="text-align:right;"> 4740 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B19001_007 </td>
   <td style="text-align:right;"> 103366 </td>
   <td style="text-align:right;"> 5246 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B19001_008 </td>
   <td style="text-align:right;"> 91011 </td>
   <td style="text-align:right;"> 4699 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B19001_009 </td>
   <td style="text-align:right;"> 86996 </td>
   <td style="text-align:right;"> 4418 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01 </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B19001_010 </td>
   <td style="text-align:right;"> 74864 </td>
   <td style="text-align:right;"> 4210 </td>
  </tr>
</tbody>
</table>

In this example, each row represents state-characteristic combinations, consistent with the tidy data model. Alternatively, if a user desires the variables spread across the columns of the dataset, the setting `output = "wide"` will enable this. For ACS data, estimates and margins of error for each ACS variable will be found in their own columns. For example:


```r
hhinc_wide <- get_acs(
  geography = "state", 
  table = "B19001", 
  survey = "acs1", 
  year = 2016,
  output = "wide"
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:state-income-table-wide-show)Income table in wide form</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_001E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_001M </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_002E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_002M </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_003E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_003M </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_004E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_004M </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_005E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_005M </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_006E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_006M </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_007E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_007M </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_008E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_008M </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_009E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_009M </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_010E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_010M </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_011E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_011M </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_012E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_012M </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_013E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_013M </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_014E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_014M </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_015E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_015M </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_016E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_016M </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_017E </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> B19001_017M </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 28 </td>
   <td style="text-align:left;"> Mississippi </td>
   <td style="text-align:right;"> 1091245 </td>
   <td style="text-align:right;"> 8803 </td>
   <td style="text-align:right;"> 113124 </td>
   <td style="text-align:right;"> 4835 </td>
   <td style="text-align:right;"> 87136 </td>
   <td style="text-align:right;"> 5004 </td>
   <td style="text-align:right;"> 71206 </td>
   <td style="text-align:right;"> 4058 </td>
   <td style="text-align:right;"> 70160 </td>
   <td style="text-align:right;"> 4560 </td>
   <td style="text-align:right;"> 59619 </td>
   <td style="text-align:right;"> 4105 </td>
   <td style="text-align:right;"> 62688 </td>
   <td style="text-align:right;"> 4149 </td>
   <td style="text-align:right;"> 55973 </td>
   <td style="text-align:right;"> 4422 </td>
   <td style="text-align:right;"> 57215 </td>
   <td style="text-align:right;"> 4119 </td>
   <td style="text-align:right;"> 41870 </td>
   <td style="text-align:right;"> 3427 </td>
   <td style="text-align:right;"> 86198 </td>
   <td style="text-align:right;"> 4669 </td>
   <td style="text-align:right;"> 98865 </td>
   <td style="text-align:right;"> 5983 </td>
   <td style="text-align:right;"> 117664 </td>
   <td style="text-align:right;"> 5168 </td>
   <td style="text-align:right;"> 68367 </td>
   <td style="text-align:right;"> 4079 </td>
   <td style="text-align:right;"> 37809 </td>
   <td style="text-align:right;"> 2983 </td>
   <td style="text-align:right;"> 34786 </td>
   <td style="text-align:right;"> 3038 </td>
   <td style="text-align:right;"> 28565 </td>
   <td style="text-align:right;"> 2396 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 29 </td>
   <td style="text-align:left;"> Missouri </td>
   <td style="text-align:right;"> 2372190 </td>
   <td style="text-align:right;"> 10844 </td>
   <td style="text-align:right;"> 160615 </td>
   <td style="text-align:right;"> 6705 </td>
   <td style="text-align:right;"> 122649 </td>
   <td style="text-align:right;"> 4654 </td>
   <td style="text-align:right;"> 123789 </td>
   <td style="text-align:right;"> 5201 </td>
   <td style="text-align:right;"> 128270 </td>
   <td style="text-align:right;"> 5714 </td>
   <td style="text-align:right;"> 123224 </td>
   <td style="text-align:right;"> 4726 </td>
   <td style="text-align:right;"> 133429 </td>
   <td style="text-align:right;"> 5639 </td>
   <td style="text-align:right;"> 123373 </td>
   <td style="text-align:right;"> 4564 </td>
   <td style="text-align:right;"> 117476 </td>
   <td style="text-align:right;"> 5796 </td>
   <td style="text-align:right;"> 107254 </td>
   <td style="text-align:right;"> 4130 </td>
   <td style="text-align:right;"> 200473 </td>
   <td style="text-align:right;"> 6468 </td>
   <td style="text-align:right;"> 248099 </td>
   <td style="text-align:right;"> 6281 </td>
   <td style="text-align:right;"> 296437 </td>
   <td style="text-align:right;"> 7492 </td>
   <td style="text-align:right;"> 188700 </td>
   <td style="text-align:right;"> 6361 </td>
   <td style="text-align:right;"> 102034 </td>
   <td style="text-align:right;"> 4905 </td>
   <td style="text-align:right;"> 102670 </td>
   <td style="text-align:right;"> 4935 </td>
   <td style="text-align:right;"> 93698 </td>
   <td style="text-align:right;"> 4434 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 30 </td>
   <td style="text-align:left;"> Montana </td>
   <td style="text-align:right;"> 416125 </td>
   <td style="text-align:right;"> 4426 </td>
   <td style="text-align:right;"> 26734 </td>
   <td style="text-align:right;"> 2183 </td>
   <td style="text-align:right;"> 24786 </td>
   <td style="text-align:right;"> 2391 </td>
   <td style="text-align:right;"> 22330 </td>
   <td style="text-align:right;"> 2391 </td>
   <td style="text-align:right;"> 22193 </td>
   <td style="text-align:right;"> 2098 </td>
   <td style="text-align:right;"> 22568 </td>
   <td style="text-align:right;"> 2191 </td>
   <td style="text-align:right;"> 24449 </td>
   <td style="text-align:right;"> 2343 </td>
   <td style="text-align:right;"> 22135 </td>
   <td style="text-align:right;"> 2094 </td>
   <td style="text-align:right;"> 22241 </td>
   <td style="text-align:right;"> 1974 </td>
   <td style="text-align:right;"> 20513 </td>
   <td style="text-align:right;"> 1987 </td>
   <td style="text-align:right;"> 33707 </td>
   <td style="text-align:right;"> 2860 </td>
   <td style="text-align:right;"> 43775 </td>
   <td style="text-align:right;"> 3112 </td>
   <td style="text-align:right;"> 50902 </td>
   <td style="text-align:right;"> 2878 </td>
   <td style="text-align:right;"> 29940 </td>
   <td style="text-align:right;"> 2823 </td>
   <td style="text-align:right;"> 18585 </td>
   <td style="text-align:right;"> 1928 </td>
   <td style="text-align:right;"> 15669 </td>
   <td style="text-align:right;"> 1603 </td>
   <td style="text-align:right;"> 15598 </td>
   <td style="text-align:right;"> 1511 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 31 </td>
   <td style="text-align:left;"> Nebraska </td>
   <td style="text-align:right;"> 747562 </td>
   <td style="text-align:right;"> 4452 </td>
   <td style="text-align:right;"> 45794 </td>
   <td style="text-align:right;"> 3116 </td>
   <td style="text-align:right;"> 33266 </td>
   <td style="text-align:right;"> 2466 </td>
   <td style="text-align:right;"> 31084 </td>
   <td style="text-align:right;"> 2533 </td>
   <td style="text-align:right;"> 37602 </td>
   <td style="text-align:right;"> 2475 </td>
   <td style="text-align:right;"> 38037 </td>
   <td style="text-align:right;"> 3067 </td>
   <td style="text-align:right;"> 40412 </td>
   <td style="text-align:right;"> 2841 </td>
   <td style="text-align:right;"> 36761 </td>
   <td style="text-align:right;"> 2757 </td>
   <td style="text-align:right;"> 35558 </td>
   <td style="text-align:right;"> 2474 </td>
   <td style="text-align:right;"> 33429 </td>
   <td style="text-align:right;"> 2688 </td>
   <td style="text-align:right;"> 57950 </td>
   <td style="text-align:right;"> 3212 </td>
   <td style="text-align:right;"> 83173 </td>
   <td style="text-align:right;"> 4291 </td>
   <td style="text-align:right;"> 99028 </td>
   <td style="text-align:right;"> 4389 </td>
   <td style="text-align:right;"> 69003 </td>
   <td style="text-align:right;"> 3272 </td>
   <td style="text-align:right;"> 37347 </td>
   <td style="text-align:right;"> 2482 </td>
   <td style="text-align:right;"> 37665 </td>
   <td style="text-align:right;"> 2540 </td>
   <td style="text-align:right;"> 31453 </td>
   <td style="text-align:right;"> 2166 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 32 </td>
   <td style="text-align:left;"> Nevada </td>
   <td style="text-align:right;"> 1055158 </td>
   <td style="text-align:right;"> 6433 </td>
   <td style="text-align:right;"> 68507 </td>
   <td style="text-align:right;"> 4886 </td>
   <td style="text-align:right;"> 42720 </td>
   <td style="text-align:right;"> 3071 </td>
   <td style="text-align:right;"> 53143 </td>
   <td style="text-align:right;"> 3653 </td>
   <td style="text-align:right;"> 53188 </td>
   <td style="text-align:right;"> 3403 </td>
   <td style="text-align:right;"> 56693 </td>
   <td style="text-align:right;"> 3758 </td>
   <td style="text-align:right;"> 57215 </td>
   <td style="text-align:right;"> 3909 </td>
   <td style="text-align:right;"> 50798 </td>
   <td style="text-align:right;"> 4207 </td>
   <td style="text-align:right;"> 53783 </td>
   <td style="text-align:right;"> 3826 </td>
   <td style="text-align:right;"> 44637 </td>
   <td style="text-align:right;"> 3558 </td>
   <td style="text-align:right;"> 87876 </td>
   <td style="text-align:right;"> 4032 </td>
   <td style="text-align:right;"> 116975 </td>
   <td style="text-align:right;"> 4704 </td>
   <td style="text-align:right;"> 135242 </td>
   <td style="text-align:right;"> 4728 </td>
   <td style="text-align:right;"> 88474 </td>
   <td style="text-align:right;"> 4750 </td>
   <td style="text-align:right;"> 54275 </td>
   <td style="text-align:right;"> 3382 </td>
   <td style="text-align:right;"> 45943 </td>
   <td style="text-align:right;"> 3019 </td>
   <td style="text-align:right;"> 45689 </td>
   <td style="text-align:right;"> 3255 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 33 </td>
   <td style="text-align:left;"> New Hampshire </td>
   <td style="text-align:right;"> 520643 </td>
   <td style="text-align:right;"> 5191 </td>
   <td style="text-align:right;"> 20890 </td>
   <td style="text-align:right;"> 2566 </td>
   <td style="text-align:right;"> 15933 </td>
   <td style="text-align:right;"> 1908 </td>
   <td style="text-align:right;"> 18190 </td>
   <td style="text-align:right;"> 2315 </td>
   <td style="text-align:right;"> 18067 </td>
   <td style="text-align:right;"> 1841 </td>
   <td style="text-align:right;"> 21680 </td>
   <td style="text-align:right;"> 2292 </td>
   <td style="text-align:right;"> 22695 </td>
   <td style="text-align:right;"> 2067 </td>
   <td style="text-align:right;"> 21064 </td>
   <td style="text-align:right;"> 2112 </td>
   <td style="text-align:right;"> 17717 </td>
   <td style="text-align:right;"> 2340 </td>
   <td style="text-align:right;"> 21086 </td>
   <td style="text-align:right;"> 2454 </td>
   <td style="text-align:right;"> 39534 </td>
   <td style="text-align:right;"> 3108 </td>
   <td style="text-align:right;"> 57994 </td>
   <td style="text-align:right;"> 3587 </td>
   <td style="text-align:right;"> 75337 </td>
   <td style="text-align:right;"> 4214 </td>
   <td style="text-align:right;"> 56445 </td>
   <td style="text-align:right;"> 3069 </td>
   <td style="text-align:right;"> 33685 </td>
   <td style="text-align:right;"> 2445 </td>
   <td style="text-align:right;"> 41092 </td>
   <td style="text-align:right;"> 3028 </td>
   <td style="text-align:right;"> 39234 </td>
   <td style="text-align:right;"> 2925 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 34 </td>
   <td style="text-align:left;"> New Jersey </td>
   <td style="text-align:right;"> 3194519 </td>
   <td style="text-align:right;"> 10274 </td>
   <td style="text-align:right;"> 170029 </td>
   <td style="text-align:right;"> 6836 </td>
   <td style="text-align:right;"> 118862 </td>
   <td style="text-align:right;"> 5855 </td>
   <td style="text-align:right;"> 123335 </td>
   <td style="text-align:right;"> 6065 </td>
   <td style="text-align:right;"> 121889 </td>
   <td style="text-align:right;"> 4670 </td>
   <td style="text-align:right;"> 120881 </td>
   <td style="text-align:right;"> 5562 </td>
   <td style="text-align:right;"> 113762 </td>
   <td style="text-align:right;"> 5328 </td>
   <td style="text-align:right;"> 112003 </td>
   <td style="text-align:right;"> 5795 </td>
   <td style="text-align:right;"> 110312 </td>
   <td style="text-align:right;"> 6000 </td>
   <td style="text-align:right;"> 100527 </td>
   <td style="text-align:right;"> 4994 </td>
   <td style="text-align:right;"> 207103 </td>
   <td style="text-align:right;"> 6096 </td>
   <td style="text-align:right;"> 277719 </td>
   <td style="text-align:right;"> 8225 </td>
   <td style="text-align:right;"> 390127 </td>
   <td style="text-align:right;"> 9002 </td>
   <td style="text-align:right;"> 328144 </td>
   <td style="text-align:right;"> 8879 </td>
   <td style="text-align:right;"> 220764 </td>
   <td style="text-align:right;"> 7203 </td>
   <td style="text-align:right;"> 295764 </td>
   <td style="text-align:right;"> 7663 </td>
   <td style="text-align:right;"> 383298 </td>
   <td style="text-align:right;"> 7529 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 35 </td>
   <td style="text-align:left;"> New Mexico </td>
   <td style="text-align:right;"> 758364 </td>
   <td style="text-align:right;"> 6296 </td>
   <td style="text-align:right;"> 66983 </td>
   <td style="text-align:right;"> 4439 </td>
   <td style="text-align:right;"> 48930 </td>
   <td style="text-align:right;"> 3220 </td>
   <td style="text-align:right;"> 50025 </td>
   <td style="text-align:right;"> 4091 </td>
   <td style="text-align:right;"> 48054 </td>
   <td style="text-align:right;"> 3477 </td>
   <td style="text-align:right;"> 40353 </td>
   <td style="text-align:right;"> 3418 </td>
   <td style="text-align:right;"> 38164 </td>
   <td style="text-align:right;"> 2931 </td>
   <td style="text-align:right;"> 35107 </td>
   <td style="text-align:right;"> 2934 </td>
   <td style="text-align:right;"> 37564 </td>
   <td style="text-align:right;"> 2815 </td>
   <td style="text-align:right;"> 34581 </td>
   <td style="text-align:right;"> 2684 </td>
   <td style="text-align:right;"> 59437 </td>
   <td style="text-align:right;"> 3388 </td>
   <td style="text-align:right;"> 73011 </td>
   <td style="text-align:right;"> 3581 </td>
   <td style="text-align:right;"> 87486 </td>
   <td style="text-align:right;"> 4182 </td>
   <td style="text-align:right;"> 55708 </td>
   <td style="text-align:right;"> 3629 </td>
   <td style="text-align:right;"> 29307 </td>
   <td style="text-align:right;"> 2585 </td>
   <td style="text-align:right;"> 26732 </td>
   <td style="text-align:right;"> 2351 </td>
   <td style="text-align:right;"> 26922 </td>
   <td style="text-align:right;"> 2608 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 36 </td>
   <td style="text-align:left;"> New York </td>
   <td style="text-align:right;"> 7209054 </td>
   <td style="text-align:right;"> 17665 </td>
   <td style="text-align:right;"> 543763 </td>
   <td style="text-align:right;"> 12132 </td>
   <td style="text-align:right;"> 352029 </td>
   <td style="text-align:right;"> 9607 </td>
   <td style="text-align:right;"> 322683 </td>
   <td style="text-align:right;"> 7756 </td>
   <td style="text-align:right;"> 327051 </td>
   <td style="text-align:right;"> 8184 </td>
   <td style="text-align:right;"> 297201 </td>
   <td style="text-align:right;"> 8689 </td>
   <td style="text-align:right;"> 316465 </td>
   <td style="text-align:right;"> 9191 </td>
   <td style="text-align:right;"> 285531 </td>
   <td style="text-align:right;"> 8078 </td>
   <td style="text-align:right;"> 277776 </td>
   <td style="text-align:right;"> 8886 </td>
   <td style="text-align:right;"> 239908 </td>
   <td style="text-align:right;"> 8368 </td>
   <td style="text-align:right;"> 485826 </td>
   <td style="text-align:right;"> 10467 </td>
   <td style="text-align:right;"> 648930 </td>
   <td style="text-align:right;"> 12717 </td>
   <td style="text-align:right;"> 864777 </td>
   <td style="text-align:right;"> 14413 </td>
   <td style="text-align:right;"> 646586 </td>
   <td style="text-align:right;"> 12798 </td>
   <td style="text-align:right;"> 432309 </td>
   <td style="text-align:right;"> 11182 </td>
   <td style="text-align:right;"> 521545 </td>
   <td style="text-align:right;"> 11193 </td>
   <td style="text-align:right;"> 646674 </td>
   <td style="text-align:right;"> 9931 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 37 </td>
   <td style="text-align:left;"> North Carolina </td>
   <td style="text-align:right;"> 3882423 </td>
   <td style="text-align:right;"> 16063 </td>
   <td style="text-align:right;"> 282491 </td>
   <td style="text-align:right;"> 7816 </td>
   <td style="text-align:right;"> 228088 </td>
   <td style="text-align:right;"> 7916 </td>
   <td style="text-align:right;"> 209825 </td>
   <td style="text-align:right;"> 6844 </td>
   <td style="text-align:right;"> 212659 </td>
   <td style="text-align:right;"> 7095 </td>
   <td style="text-align:right;"> 206371 </td>
   <td style="text-align:right;"> 7190 </td>
   <td style="text-align:right;"> 215759 </td>
   <td style="text-align:right;"> 6349 </td>
   <td style="text-align:right;"> 190497 </td>
   <td style="text-align:right;"> 7507 </td>
   <td style="text-align:right;"> 199257 </td>
   <td style="text-align:right;"> 6269 </td>
   <td style="text-align:right;"> 170320 </td>
   <td style="text-align:right;"> 6503 </td>
   <td style="text-align:right;"> 318567 </td>
   <td style="text-align:right;"> 7932 </td>
   <td style="text-align:right;"> 395160 </td>
   <td style="text-align:right;"> 9069 </td>
   <td style="text-align:right;"> 468022 </td>
   <td style="text-align:right;"> 10041 </td>
   <td style="text-align:right;"> 288626 </td>
   <td style="text-align:right;"> 7339 </td>
   <td style="text-align:right;"> 160589 </td>
   <td style="text-align:right;"> 6395 </td>
   <td style="text-align:right;"> 166800 </td>
   <td style="text-align:right;"> 5286 </td>
   <td style="text-align:right;"> 169392 </td>
   <td style="text-align:right;"> 5628 </td>
  </tr>
</tbody>
</table>

The wide-form dataset includes `GEOID` and `NAME` columns, as in the tidy dataset, but is also characterized by estimate/margin of error pairs across the columns for each Census variable in the table.

### Renaming variable IDs

Census variables IDs can be cumbersome to type and remember in the course of an R session. As such, **tidycensus** has built-in tools to automatically rename the variable IDs if requested by a user. For example, let's say that a user is requesting data on median household income (variable ID `B19013_001`) and median age (variable ID `B01002_001`). By passing a *named* vector to the `variables` parameter in `get_acs()` or `get_decennial()`, the functions will return the desired names rather than the Census variable IDs. Let's examine this for counties in Georgia from the 2015-2019 five-year ACS.


```r
ga <- get_acs(
  geography = "county",
  state = "Georgia",
  variables = c(medinc = "B19013_001",
                medage = "B01002_001"),
  year = 2019
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:georgia-data-show)Multi-variable dataset for Georgia counties</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> estimate </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> moe </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 13001 </td>
   <td style="text-align:left;"> Appling County, Georgia </td>
   <td style="text-align:left;"> medage </td>
   <td style="text-align:right;"> 40.3 </td>
   <td style="text-align:right;"> 1.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13001 </td>
   <td style="text-align:left;"> Appling County, Georgia </td>
   <td style="text-align:left;"> medinc </td>
   <td style="text-align:right;"> 40304.0 </td>
   <td style="text-align:right;"> 5180.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13003 </td>
   <td style="text-align:left;"> Atkinson County, Georgia </td>
   <td style="text-align:left;"> medage </td>
   <td style="text-align:right;"> 36.4 </td>
   <td style="text-align:right;"> 1.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13003 </td>
   <td style="text-align:left;"> Atkinson County, Georgia </td>
   <td style="text-align:left;"> medinc </td>
   <td style="text-align:right;"> 37197.0 </td>
   <td style="text-align:right;"> 3686.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13005 </td>
   <td style="text-align:left;"> Bacon County, Georgia </td>
   <td style="text-align:left;"> medage </td>
   <td style="text-align:right;"> 36.7 </td>
   <td style="text-align:right;"> 0.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13005 </td>
   <td style="text-align:left;"> Bacon County, Georgia </td>
   <td style="text-align:left;"> medinc </td>
   <td style="text-align:right;"> 37519.0 </td>
   <td style="text-align:right;"> 5492.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13007 </td>
   <td style="text-align:left;"> Baker County, Georgia </td>
   <td style="text-align:left;"> medage </td>
   <td style="text-align:right;"> 46.1 </td>
   <td style="text-align:right;"> 5.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13007 </td>
   <td style="text-align:left;"> Baker County, Georgia </td>
   <td style="text-align:left;"> medinc </td>
   <td style="text-align:right;"> 32917.0 </td>
   <td style="text-align:right;"> 6967.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13009 </td>
   <td style="text-align:left;"> Baldwin County, Georgia </td>
   <td style="text-align:left;"> medage </td>
   <td style="text-align:right;"> 35.5 </td>
   <td style="text-align:right;"> 0.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13009 </td>
   <td style="text-align:left;"> Baldwin County, Georgia </td>
   <td style="text-align:left;"> medinc </td>
   <td style="text-align:right;"> 43672.0 </td>
   <td style="text-align:right;"> 3736.0 </td>
  </tr>
</tbody>
</table>

ACS variable IDs, which would be found in the `variable` column, are replaced by `medage` and `medinc`, as requested. When a wide-form dataset is requested, **tidycensus** will still append `E` and `M` to the specified column names, as illustrated below.


```r
ga_wide <- get_acs(
  geography = "county",
  state = "Georgia",
  variables = c(medinc = "B19013_001",
                medage = "B01002_001"),
  output = "wide"
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:georgia-data-wide-show)Georgia dataset in wide form</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> medincE </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> medincM </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> medageE </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> medageM </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 13005 </td>
   <td style="text-align:left;"> Bacon County, Georgia </td>
   <td style="text-align:right;"> 37519 </td>
   <td style="text-align:right;"> 5492 </td>
   <td style="text-align:right;"> 36.7 </td>
   <td style="text-align:right;"> 0.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13025 </td>
   <td style="text-align:left;"> Brantley County, Georgia </td>
   <td style="text-align:right;"> 38857 </td>
   <td style="text-align:right;"> 3480 </td>
   <td style="text-align:right;"> 41.1 </td>
   <td style="text-align:right;"> 0.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13017 </td>
   <td style="text-align:left;"> Ben Hill County, Georgia </td>
   <td style="text-align:right;"> 32229 </td>
   <td style="text-align:right;"> 3845 </td>
   <td style="text-align:right;"> 39.9 </td>
   <td style="text-align:right;"> 1.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13033 </td>
   <td style="text-align:left;"> Burke County, Georgia </td>
   <td style="text-align:right;"> 44151 </td>
   <td style="text-align:right;"> 2438 </td>
   <td style="text-align:right;"> 37.4 </td>
   <td style="text-align:right;"> 0.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13047 </td>
   <td style="text-align:left;"> Catoosa County, Georgia </td>
   <td style="text-align:right;"> 56235 </td>
   <td style="text-align:right;"> 2290 </td>
   <td style="text-align:right;"> 40.4 </td>
   <td style="text-align:right;"> 0.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13053 </td>
   <td style="text-align:left;"> Chattahoochee County, Georgia </td>
   <td style="text-align:right;"> 47096 </td>
   <td style="text-align:right;"> 5158 </td>
   <td style="text-align:right;"> 24.5 </td>
   <td style="text-align:right;"> 0.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13055 </td>
   <td style="text-align:left;"> Chattooga County, Georgia </td>
   <td style="text-align:right;"> 36807 </td>
   <td style="text-align:right;"> 2268 </td>
   <td style="text-align:right;"> 39.4 </td>
   <td style="text-align:right;"> 0.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13073 </td>
   <td style="text-align:left;"> Columbia County, Georgia </td>
   <td style="text-align:right;"> 82339 </td>
   <td style="text-align:right;"> 3532 </td>
   <td style="text-align:right;"> 36.9 </td>
   <td style="text-align:right;"> 0.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13087 </td>
   <td style="text-align:left;"> Decatur County, Georgia </td>
   <td style="text-align:right;"> 41481 </td>
   <td style="text-align:right;"> 3584 </td>
   <td style="text-align:right;"> 37.8 </td>
   <td style="text-align:right;"> 0.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13115 </td>
   <td style="text-align:left;"> Floyd County, Georgia </td>
   <td style="text-align:right;"> 48336 </td>
   <td style="text-align:right;"> 2266 </td>
   <td style="text-align:right;"> 38.3 </td>
   <td style="text-align:right;"> 0.3 </td>
  </tr>
</tbody>
</table>

Median household income for each county is represented by `medincE`, for the estimate, and `medincM`, for the margin of error. At the time of this writing, custom variable names are only available for `variables` and not for `table`, as users will not always know the number of variables found in a table beforehand.

## Other Census Bureau datasets in tidycensus

As mentioned earlier in this chapter, **tidycensus** does not grant access to all of the datasets available from the Census API; users should look at the **censusapi** package [@recht2021] for that functionality. However, the Population Estimates and ACS Migration Flows APIs are accessible with the `get_estimates()` and `get_flows()` functions, respectively. This section includes brief examples of each.

### Using `get_estimates()`

The [Population Estimates Program](https://www.census.gov/programs-surveys/popest.html), or PEP, provides yearly estimates of the US population and its components between decennial Censuses. It differs from the ACS in that it is not directly based on a dedicated survey, but rather projects forward data from the most recent decennial Census based on birth, death, and migration rates.

One advantage of using the PEP to retrieve data is that allows you to access the indicators used to produce the intercensal population estimates. These indicators can be specified as variables direction in the `get_estimates()` function in **tidycensus**, or requested in bulk by using the `product` argument. The products available include `"population"`, `"components"`, `"housing"`, and `"characteristics"`. For example, we can request all components of change population estimates for 2019 for a specific county:


```r
library(tidycensus)
library(tidyverse)

queens_components <- get_estimates(
  geography = "county",
  product = "components",
  state = "NY",
  county = "Queens",
  year = 2019
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:queens-components-show)Components of change estimates for Queens County, NY</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Queens County, New York </td>
   <td style="text-align:left;"> 36081 </td>
   <td style="text-align:left;"> BIRTHS </td>
   <td style="text-align:right;"> 27453.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Queens County, New York </td>
   <td style="text-align:left;"> 36081 </td>
   <td style="text-align:left;"> DEATHS </td>
   <td style="text-align:right;"> 16380.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Queens County, New York </td>
   <td style="text-align:left;"> 36081 </td>
   <td style="text-align:left;"> DOMESTICMIG </td>
   <td style="text-align:right;"> -41789.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Queens County, New York </td>
   <td style="text-align:left;"> 36081 </td>
   <td style="text-align:left;"> INTERNATIONALMIG </td>
   <td style="text-align:right;"> 9883.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Queens County, New York </td>
   <td style="text-align:left;"> 36081 </td>
   <td style="text-align:left;"> NATURALINC </td>
   <td style="text-align:right;"> 11073.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Queens County, New York </td>
   <td style="text-align:left;"> 36081 </td>
   <td style="text-align:left;"> NETMIG </td>
   <td style="text-align:right;"> -31906.000000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Queens County, New York </td>
   <td style="text-align:left;"> 36081 </td>
   <td style="text-align:left;"> RBIRTH </td>
   <td style="text-align:right;"> 12.124644 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Queens County, New York </td>
   <td style="text-align:left;"> 36081 </td>
   <td style="text-align:left;"> RDEATH </td>
   <td style="text-align:right;"> 7.234243 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Queens County, New York </td>
   <td style="text-align:left;"> 36081 </td>
   <td style="text-align:left;"> RDOMESTICMIG </td>
   <td style="text-align:right;"> -18.456152 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Queens County, New York </td>
   <td style="text-align:left;"> 36081 </td>
   <td style="text-align:left;"> RINTERNATIONALMIG </td>
   <td style="text-align:right;"> 4.364836 </td>
  </tr>
</tbody>
</table>

Alternatively, a single variable or vector of variables can be requested with the `variable` argument, and the `output = "wide"` argument can also be used to spread the variable names across the columns.

The `product = "characteristics"` argument also has some unique options. The argument `breakdown` lets users get breakdowns of population estimates for the US, states, and counties by `"AGEGROUP"`, `"RACE"`, `"SEX"`, or `"HISP"` (Hispanic origin). If set to `TRUE`, the `breakdown_labels` argument will return informative labels for the population estimates. For example, to get population estimates by sex and Hispanic origin for metropolitan areas, we can use the following code:


```r
louisiana_age_hisp <- get_estimates(
  geography = "state",
  product = "characteristics",
  breakdown = c("SEX", "HISP"),
  breakdown_labels = TRUE,
  state = "LA",
  year = 2019
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:louisiana-estimates-show)Population characteristics for Louisiana</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> value </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> SEX </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> HISP </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 22 </td>
   <td style="text-align:left;"> Louisiana </td>
   <td style="text-align:right;"> 4648794 </td>
   <td style="text-align:left;"> Both sexes </td>
   <td style="text-align:left;"> Both Hispanic Origins </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 22 </td>
   <td style="text-align:left;"> Louisiana </td>
   <td style="text-align:right;"> 4401822 </td>
   <td style="text-align:left;"> Both sexes </td>
   <td style="text-align:left;"> Non-Hispanic </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 22 </td>
   <td style="text-align:left;"> Louisiana </td>
   <td style="text-align:right;"> 246972 </td>
   <td style="text-align:left;"> Both sexes </td>
   <td style="text-align:left;"> Hispanic </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 22 </td>
   <td style="text-align:left;"> Louisiana </td>
   <td style="text-align:right;"> 2267050 </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> Both Hispanic Origins </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 22 </td>
   <td style="text-align:left;"> Louisiana </td>
   <td style="text-align:right;"> 2135979 </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> Non-Hispanic </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 22 </td>
   <td style="text-align:left;"> Louisiana </td>
   <td style="text-align:right;"> 131071 </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:left;"> Hispanic </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 22 </td>
   <td style="text-align:left;"> Louisiana </td>
   <td style="text-align:right;"> 2381744 </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> Both Hispanic Origins </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 22 </td>
   <td style="text-align:left;"> Louisiana </td>
   <td style="text-align:right;"> 2265843 </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> Non-Hispanic </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 22 </td>
   <td style="text-align:left;"> Louisiana </td>
   <td style="text-align:right;"> 115901 </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:left;"> Hispanic </td>
  </tr>
</tbody>
</table>

### Using `get_flows()`

As of version 1.0, **tidycensus** also includes support for the ACS Migration Flows API. The flows API returns information on both in- and out-migration for states, counties, and metropolitan areas. By default, the function allows for analysis of in-migrants, emigrants, and net migration for a given geography using data from a given 5-year ACS sample. In the example below, we request migration data for Honolulu County, Hawaii. In-migration for world regions is available along with out-migration and net migration for US locations.


```r
honolulu_migration <- get_flows(
  geography = "county",
  state = "HI",
  county = "Honolulu",
  year = 2018,
  show_call = TRUE
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:honolulu-migration-show)Migration flows data for Honolulu, HI</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID1 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID2 </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> FULL1_NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> FULL2_NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> estimate </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> moe </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 15003 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Honolulu County, Hawaii </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:left;"> MOVEDIN </td>
   <td style="text-align:right;"> 86 </td>
   <td style="text-align:right;"> 70 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 15003 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Honolulu County, Hawaii </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:left;"> MOVEDOUT </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 15003 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Honolulu County, Hawaii </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:left;"> MOVEDNET </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 15003 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Honolulu County, Hawaii </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:left;"> MOVEDIN </td>
   <td style="text-align:right;"> 7620 </td>
   <td style="text-align:right;"> 891 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 15003 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Honolulu County, Hawaii </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:left;"> MOVEDOUT </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 15003 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Honolulu County, Hawaii </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:left;"> MOVEDNET </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 15003 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Honolulu County, Hawaii </td>
   <td style="text-align:left;"> Central America </td>
   <td style="text-align:left;"> MOVEDIN </td>
   <td style="text-align:right;"> 228 </td>
   <td style="text-align:right;"> 98 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 15003 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Honolulu County, Hawaii </td>
   <td style="text-align:left;"> Central America </td>
   <td style="text-align:left;"> MOVEDOUT </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 15003 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Honolulu County, Hawaii </td>
   <td style="text-align:left;"> Central America </td>
   <td style="text-align:left;"> MOVEDNET </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 15003 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Honolulu County, Hawaii </td>
   <td style="text-align:left;"> Caribbean </td>
   <td style="text-align:left;"> MOVEDIN </td>
   <td style="text-align:right;"> 106 </td>
   <td style="text-align:right;"> 94 </td>
  </tr>
</tbody>
</table>

`get_flows()` also includes functionality for migration flow mapping; this advanced feature will be covered in Section \@ref(mapping-migration-flows).

## Debugging tidycensus errors

At times, you may think that you've formatted your use of a **tidycensus** function correctly but the Census API doesn't return the data you expected. Whenever possible, **tidycensus** carries through the error message from the Census API or translates common errors for the user. In the example below, a user has mis-typed the variable ID:


```r
state_pop <- get_decennial(
  geography = "state",
  variables = "P01001",
  year = 2010
)
```

```
## Error : Your API call has errors.  The API message returned is error: error: unknown variable 'P01001'.
```

```
## Error in UseMethod("gather"): no applicable method for 'gather' applied to an object of class "character"
```

The "unknown variable" error message from the Census API is carried through to the user. In other instances, users might request geographies that are not available in a given dataset:


```r
cbsa_ohio <- get_acs(
  geography = "cbsa",
  variables = "DP02_0068P",
  state = "OH",
  year = 2019
)
```

```
## Error: Your API call has errors.  The API message returned is error: unknown/unsupported geography heirarchy.
```

The user above has attempted to get bachelor's degree attainment by CBSA in Ohio from the ACS Data Profile. However, CBSA geographies are not available by state given that many CBSAs cross state boundaries. In response, the API returns an "unsupported geography hierarchy" error.

To assist with debugging errors, or more generally to help users understand how **tidycensus** functions are being translated to Census API calls, **tidycensus** offers a parameter `show_call` that when set to `TRUE` prints out the actual API call that **tidycensus** is making to the Census API.


```r
cbsa_bachelors <- get_acs(
  geography = "cbsa",
  variables = "DP02_0068P",
  year = 2019,
  show_call = TRUE
)
```

```
## Getting data from the 2015-2019 5-year ACS
```

```
## Using the ACS Data Profile
```

```
## Census API call: https://api.census.gov/data/2019/acs/acs5/profile?get=DP02_0068PE%2CDP02_0068PM%2CNAME&for=metropolitan%20statistical%20area%2Fmicropolitan%20statistical%20area%3A%2A
```

The printed URL [`https://api.census.gov/data/2019/acs/acs5/profile?get=DP02_0068PE%2CDP02_0068PM%2CNAME&for=metropolitan%20statistical%20area%2Fmicropolitan%20statistical%20area%3A%2A`](https://api.census.gov/data/2019/acs/acs5/profile?get=DP02_0068PE%2CDP02_0068PM%2CNAME&for=metropolitan%20statistical%20area%2Fmicropolitan%20statistical%20area%3A%2A) can be copy-pasted into a web browser where users can see the raw JSON returned by the Census API and inspect the results.

``` {.json}
[["DP02_0068PE","DP02_0068PM","NAME","metropolitan statistical area/micropolitan statistical area"],
["15.7","1.5","Big Stone Gap, VA Micro Area","13720"],
["31.6","1.0","Billings, MT Metro Area","13740"],
["27.9","0.7","Binghamton, NY Metro Area","13780"],
["31.4","0.4","Birmingham-Hoover, AL Metro Area","13820"],
["33.3","1.0","Bismarck, ND Metro Area","13900"],
["21.2","2.0","Blackfoot, ID Micro Area","13940"],
["35.2","1.1","Blacksburg-Christiansburg, VA Metro Area","13980"],
["44.8","1.1","Bloomington, IL Metro Area","14010"],
["40.8","1.2","Bloomington, IN Metro Area","14020"],
["24.9","1.0","Bloomsburg-Berwick, PA Metro Area","14100"],
...
```

## Exercises

1.  Review the available geographies in tidycensus from the geography table in this chapter. Acquire data on median age (variable `B01002_001`) for a geography we have not yet used.

2.  Use the `load_variables()` function to find a variable that interests you that we haven't used yet. Use `get_acs()` to fetch data from the 2015-2019 ACS for counties in the state where you live, where you have visited, or where you would like to visit.
