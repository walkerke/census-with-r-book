---
bibliography: references.bib
---

# An introduction to tidycensus



The **tidycensus** package [@walker_and_herman2021], first released in 2017, is an R package designed to facilitate the process of acquiring and working with US Census Bureau population data in the R environment. The package has two distinct goals. First, tidycensus aims to make Census data available to R users in a tidyverse-friendly format, helping kick-start the process of generating insights from US Census data. Second, the package is designed to streamline the data wrangling process for spatial Census data analysts. With tidycensus, R users can request *geometry* along with attributes for their Census data, helping facilitate mapping and spatial analysis. This functionality of tidycensus is covered in more depth in Chapters 6 through 8.

As discussed in the previous chapter, the US Census Bureau makes a wide range of datasets available to the user community through their APIs and other data download resources. tidycensus is not a comprehensive portal to these data resources; instead, it focuses on a select number of datasets implemented in a series of core functions. These core functions in tidycensus include:

-   `get_decennial()`, which requests data from the US Decennial Census APIs for 2000 and 2010. When 2020 Census data are released via the API, R users will be able to access it with this function as well.

-   `get_acs()`, which requests data from the 1-year and 5-year American Community Survey samples. Data are available from the 1-year ACS back to 2005 and the 5-year ACS back to 2005-2009.

-   `get_estimates()`, an interface to the Population Estimates APIs. These datasets include yearly estimates of population characteristics by state, county, and metropolitan area, along with components of change demographic estimates like births, deaths, and migration rates.

-   `get_pums()`, which accesses data from the ACS Public Use Microdata Sample APIs. These samples include anonymized individual-level records from the ACS organized by household and are highly useful for many different social science analyses. `get_pums()` is covered in more depth in Chapters 9 and 10.

-   `get_flows()`, an interface to the ACS Migration Flows APIs. Includes information on in- and out-flows from various geographies for the 5-year ACS samples, enabling origin-destination analyses.

## Getting started with tidycensus

To get started with tidycensus, users should load the package along with the **tidyverse** package and set their Census API key with the `census_api_key()` function. API keys can be obtained at <https://api.census.gov/data/key_signup.html>. After you've signed up for an API key, be sure to activate the key from the email you receive from the Census Bureau so it works correctly. Declaring `install = TRUE` when calling `census_api_key()` will install the key for use in future R sessions, which may be convenient for many users.


```r
library(tidycensus)
library(tidyverse)
# census_api_key("YOUR KEY GOES HERE", install = TRUE)
```

### Decennial Census

Once an API key is installed, users can obtain decennial Census or ACS data with a single function call. Let's start with `get_decennial()`, which is used to access decennial Census data from the 2000 and 2010 Censuses. To get data from the decennial US Census, users must specify a string representing the requested `geography`; a vector of Census variable IDs, represented by `variable`; or optionally a Census table ID, passed to `table`.


```r
pop10 <- get_decennial(
  geography = "state", 
  variables = "P001001",
  year = 2010
)

head(pop10)
```

```
## # A tibble: 6 x 4
##   GEOID NAME       variable    value
##   <chr> <chr>      <chr>       <dbl>
## 1 01    Alabama    P001001   4779736
## 2 02    Alaska     P001001    710231
## 3 04    Arizona    P001001   6392017
## 4 05    Arkansas   P001001   2915918
## 5 06    California P001001  37253956
## 6 22    Louisiana  P001001   4533372
```

The function returns a tibble of data from the 2010 US Census (the function default year) with information on total population by state. Data for 2000 can also be obtained by supplying the appropriate year to the `year` parameter.

### American Community Survey

Similarly, `get_acs()` retrieves data from the American Community Survey.


```r
pop15to19 <- get_acs(
  geography = "state", 
  variables = "B01003_001",
  year = 2019
)

pop15to19
```

```
## # A tibble: 52 x 5
##    GEOID NAME                 variable   estimate   moe
##    <chr> <chr>                <chr>         <dbl> <dbl>
##  1 01    Alabama              B01003_001  4876250    NA
##  2 02    Alaska               B01003_001   737068    NA
##  3 04    Arizona              B01003_001  7050299    NA
##  4 05    Arkansas             B01003_001  2999370    NA
##  5 06    California           B01003_001 39283497    NA
##  6 08    Colorado             B01003_001  5610349    NA
##  7 09    Connecticut          B01003_001  3575074    NA
##  8 10    Delaware             B01003_001   957248    NA
##  9 11    District of Columbia B01003_001   692683    NA
## 10 12    Florida              B01003_001 20901636    NA
## # … with 42 more rows
```

If the year is not specified, `get_acs()` defaults to the most recent five-year ACS sample, which at the time of this writing is 2015-2019. The data returned is similar in structure to that returned by `get_decennial()`, but includes an `estimate` column (for the ACS estimate) and `moe` column (for the margin of error around that estimate) instead of a `value` column. Different years and different surveys are available by adjusting the `year` and `survey` parameters. For example, the following code will fetch data from the 1-year ACS for 2019:


```r
pop19 <- get_acs(
  geography = "state", 
  variables = "B01003_001", 
  survey = "acs1",
  year = 2019
)

pop19
```

```
## # A tibble: 52 x 5
##    GEOID NAME                 variable   estimate   moe
##    <chr> <chr>                <chr>         <dbl> <dbl>
##  1 01    Alabama              B01003_001  4903185    NA
##  2 02    Alaska               B01003_001   731545    NA
##  3 04    Arizona              B01003_001  7278717    NA
##  4 05    Arkansas             B01003_001  3017804    NA
##  5 06    California           B01003_001 39512223    NA
##  6 08    Colorado             B01003_001  5758736    NA
##  7 09    Connecticut          B01003_001  3565287    NA
##  8 10    Delaware             B01003_001   973764    NA
##  9 11    District of Columbia B01003_001   705749    NA
## 10 12    Florida              B01003_001 21477737    NA
## # … with 42 more rows
```

Variables from the ACS detailed tables, data profiles, and summary tables are available through tidycensus's `get_acs()` function; the function will auto-detect from which dataset to look for variables. Alternatively, users can supply a table name to the `table` parameter in `get_acs()`; this will return data for every variable in that table. For example, to get all variables associated with table B01001, which covers sex broken down by age, from the 2015-2019 5-year ACS:


```r
age_table <- get_acs(
  geography = "state", 
  table = "B01001",
  year = 2019
)

age_table
```

```
## # A tibble: 2,548 x 5
##    GEOID NAME    variable   estimate   moe
##    <chr> <chr>   <chr>         <dbl> <dbl>
##  1 01    Alabama B01001_001  4876250    NA
##  2 01    Alabama B01001_002  2359355  1270
##  3 01    Alabama B01001_003   149090   704
##  4 01    Alabama B01001_004   153494  2290
##  5 01    Alabama B01001_005   158617  2274
##  6 01    Alabama B01001_006    98257   468
##  7 01    Alabama B01001_007    64980   834
##  8 01    Alabama B01001_008    35870  1436
##  9 01    Alabama B01001_009    35040  1472
## 10 01    Alabama B01001_010    95065  1916
## # … with 2,538 more rows
```

To find all of the variables associated with a given ACS table, tidycensus downloads a dataset of variables from the Census Bureau website and looks up the variable codes for download. If the `cache_table` parameter is set to `TRUE`, the function instructs tidycensus to cache this dataset on the user's computer for faster future access. This only needs to be done once per ACS or Census dataset if the user would like to specify this option.

## Geography and variables in tidycensus

The `geography` parameter in `get_acs()` and `get_decennial()` allows users to request data aggregated to common Census enumeration units. At the time of this writing, tidycensus accepts enumeration units nested within states and/or counties, when applicable. Census blocks are available in `get_decennial()` but not in `get_acs()` as block-level data are not available from the American Community Survey. To request data within states and/or counties, state and county names can be supplied to the `state` and `county` parameters, respectively. Arguments should be formatted in the way that they are accepted by the US Census Bureau API, specified in the table below. If an "Available by" geography is in bold, that argument is required for that geography.

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

The geography parameter must be typed exactly as specified in the table above to request data correctly from the Census API; use the table above as a reference and copy-paste for longer strings. For core-based statistical areas and zip code tabulation areas, two heavily-requested geographies, the aliases `"cbsa"` and `"zcta"` can be used, respectively, to fetch data for those geographies.


```r
cbsa_population <- get_acs(
  geography = "cbsa",
  variables = "B01003_001",
  year = 2019
)

cbsa_population
```

```
## # A tibble: 938 x 5
##    GEOID NAME                             variable   estimate   moe
##    <chr> <chr>                            <chr>         <dbl> <dbl>
##  1 10100 Aberdeen, SD Micro Area          B01003_001    42824    NA
##  2 10140 Aberdeen, WA Micro Area          B01003_001    72779    NA
##  3 10180 Abilene, TX Metro Area           B01003_001   170669    NA
##  4 10220 Ada, OK Micro Area               B01003_001    38355    NA
##  5 10300 Adrian, MI Micro Area            B01003_001    98381    NA
##  6 10380 Aguadilla-Isabela, PR Metro Area B01003_001   301107    NA
##  7 10420 Akron, OH Metro Area             B01003_001   703845    NA
##  8 10460 Alamogordo, NM Micro Area        B01003_001    66137    NA
##  9 10500 Albany, GA Metro Area            B01003_001   148436    NA
## 10 10540 Albany-Lebanon, OR Metro Area    B01003_001   125048    NA
## # … with 928 more rows
```

### Geographic subsets

For many geographies, tidycensus supports more granular requests that are subsetted by state or even by county, if supported by the API. This information is found in the "Available by" column in the table above. If a geographic subset is in bold, it is required; if not, it is optional.

For example, an analyst might be interested in studying variations in household income in the state of Wisconsin. Although the analyst *can* request all counties in the United States, this is not necessary for this specific task. In turn, they can use the `state` parameter to subset the request for a specific state.


```r
wi_income <- get_acs(
  geography = "county", 
  variables = "B19013_001", 
  state = "WI",
  year = 2019
)

wi_income
```

```
## # A tibble: 72 x 5
##    GEOID NAME                       variable   estimate   moe
##    <chr> <chr>                      <chr>         <dbl> <dbl>
##  1 55001 Adams County, Wisconsin    B19013_001    46369  1834
##  2 55003 Ashland County, Wisconsin  B19013_001    42510  2858
##  3 55005 Barron County, Wisconsin   B19013_001    52703  2104
##  4 55007 Bayfield County, Wisconsin B19013_001    56096  1877
##  5 55009 Brown County, Wisconsin    B19013_001    62340  1112
##  6 55011 Buffalo County, Wisconsin  B19013_001    57829  1873
##  7 55013 Burnett County, Wisconsin  B19013_001    52672  1388
##  8 55015 Calumet County, Wisconsin  B19013_001    75814  2425
##  9 55017 Chippewa County, Wisconsin B19013_001    59742  1759
## 10 55019 Clark County, Wisconsin    B19013_001    54012  1223
## # … with 62 more rows
```

tidycensus accepts state names (e.g. `"Wisconsin"`), state postal codes (e.g. `"WI"`), and state FIPS codes (e.g. `"55"`), so an analyst can use what they are most comfortable with.

Smaller geographies like Census tracts can also be subsetted by county. Given that Census tracts nest neatly within counties (and do not cross county boundaries), we can request all Census tracts for a given county by using the optional `county` parameter. Dane County, home to Wisconsin's capital city of Madison, is shown below. Note that the name of the county can be supplied as well as the FIPS code. If a state has two counties with similar names (e.g. "Collin" and "Collingsworth" in Texas) you'll need to spell out the full county string and type `"Collin County"`.


```r
dane_income <- get_acs(
  geography = "tract", 
  variables = "B19013_001", 
  state = "WI", 
  county = "Dane"
)

dane_income
```

```
## # A tibble: 107 x 5
##    GEOID       NAME                                     variable  estimate   moe
##    <chr>       <chr>                                    <chr>        <dbl> <dbl>
##  1 55025000100 Census Tract 1, Dane County, Wisconsin   B19013_0…    72471 12984
##  2 55025000201 Census Tract 2.01, Dane County, Wiscons… B19013_0…    94821 11860
##  3 55025000202 Census Tract 2.02, Dane County, Wiscons… B19013_0…    84145  7021
##  4 55025000204 Census Tract 2.04, Dane County, Wiscons… B19013_0…    79617 11823
##  5 55025000205 Census Tract 2.05, Dane County, Wiscons… B19013_0…    91326 13453
##  6 55025000300 Census Tract 3, Dane County, Wisconsin   B19013_0…    53778  7593
##  7 55025000401 Census Tract 4.01, Dane County, Wiscons… B19013_0…    98178  7330
##  8 55025000402 Census Tract 4.02, Dane County, Wiscons… B19013_0…   107440  6585
##  9 55025000405 Census Tract 4.05, Dane County, Wiscons… B19013_0…    68911  4141
## 10 55025000406 Census Tract 4.06, Dane County, Wiscons… B19013_0…    74489 10451
## # … with 97 more rows
```

## Searching for variables in tidycensus

One additional challenge when searching for Census variables is understanding variable IDs, which are required to fetch data from the Census and ACS APIs. There are thousands of variables available across the different datasets and summary files. To make searching easier for R users, tidycensus offers the `load_variables()` function. This function obtains a dataset of variables from the Census Bureau website and formats it for fast searching, ideally in RStudio.

The function takes two required arguments: `year`, which takes the year or endyear of the Census dataset or ACS sample, and the dataset name - one of `sf1`, `sf3`, `acs1`, or `acs5`. For the ACS datasets, append `/profile` for the Data Profile, and `/summary` for the Summary Tables. As this function requires processing thousands of variables from the Census Bureau which may take a few moments depending on the user's internet connection, the user can specify `cache = TRUE` in the function call to store the data in the user's cache directory for future access. On subsequent calls of the `load_variables()` function, `cache = TRUE` will direct the function to look in the cache directory for the variables rather than the Census website.

`load_variables()` works as follows:


```r
v16 <- load_variables(2016, "acs5", cache = TRUE)

filter(v16, str_detect(concept, "MEDIAN AGE"))
```

```
## # A tibble: 114 x 3
##    name       label                   concept                                   
##    <chr>      <chr>                   <chr>                                     
##  1 B01002_001 Estimate!!Median age!!… MEDIAN AGE BY SEX                         
##  2 B01002_002 Estimate!!Median age!!… MEDIAN AGE BY SEX                         
##  3 B01002_003 Estimate!!Median age!!… MEDIAN AGE BY SEX                         
##  4 B01002A_0… Estimate!!Median age!!… MEDIAN AGE BY SEX (WHITE ALONE)           
##  5 B01002A_0… Estimate!!Median age!!… MEDIAN AGE BY SEX (WHITE ALONE)           
##  6 B01002A_0… Estimate!!Median age!!… MEDIAN AGE BY SEX (WHITE ALONE)           
##  7 B01002B_0… Estimate!!Median age!!… MEDIAN AGE BY SEX (BLACK OR AFRICAN AMERI…
##  8 B01002B_0… Estimate!!Median age!!… MEDIAN AGE BY SEX (BLACK OR AFRICAN AMERI…
##  9 B01002B_0… Estimate!!Median age!!… MEDIAN AGE BY SEX (BLACK OR AFRICAN AMERI…
## 10 B01002C_0… Estimate!!Median age!!… MEDIAN AGE BY SEX (AMERICAN INDIAN AND AL…
## # … with 104 more rows
```

The resultant data frame has three columns: `name`, which refers to the Census variable ID; `label`, which is a descriptive data label for the variable; and `concept`, which refers to the topic of the data and often corresponds to a table of Census data. As illustrated above, the data frame can be filtered using tidyverse tools for variable exploration. However, the RStudio integrated development environment includes an interactive data viewer which is ideal for browsing this dataset, and allows for interactive sorting and filtering. The data viewer can be accessed with the `View()` function:


```r
View(v16)
```

![data viewer](img/view.png)

By browsing the table in this way, users can identify the appropriate variable IDs (found in the `name` column) that can be passed to the `variables` parameter in `get_acs()` or `get_decennial()`. Users may note that the raw variable IDs in the ACS, as consumed by the API, require a suffix of `E` or `M`. tidycensus does not require this suffix, as it will automatically return both the estimate and margin of error for a given requested variable. Additionally, if users desire an entire table of related variables from the ACS, the user should supply the characters prior to the underscore from a variable ID to the `table` parameter.

## Data structure in tidycensus

Key to the design philosophy of tidycensus is its interpretation of tidy data. Following [@wickham2014], "tidy" data are defined as follows:

1.  Each observation forms a row;
2.  Each variable forms a column;
3.  Each observational unit forms a table.

By default, tidycensus returns a tibble of ACS or decennial Census data in "tidy" format. For decennial Census data, this will include four columns:

-   `GEOID`, representing the Census ID code that uniquely identifies the geographic unit;

-   `NAME`, which represents a descriptive name of the unit;

-   `variable`, which contains information on the Census variable name corresponding to that row;

-   `value`, which contains the data values for each unit-variable combination. For ACS data, two columns replace the `value` column: `estimate`, which represents the ACS estimate, and `moe`, representing the margin of error around that estimate.

Given the terminology used by the Census Bureau to distinguish data, it is important to provide some clarifications of nomenclature here. Census or ACS **variables**, which are specific series of data available by enumeration unit, are interpreted in tidycensus as *characteristics* of those enumeration units. In turn, rows in datasets returned when `output = "tidy"`, which is the default setting in the `get_acs()` and `get_decennial()` functions, represent data for unique unit-variable combinations. An example of this is illustrated below with income groups by state for the 2016 1-year American Community Survey.


```r
hhinc <- get_acs(
  geography = "state", 
  table = "B19001", 
  survey = "acs1",
  year = 2016
)

hhinc
```

```
## # A tibble: 884 x 5
##    GEOID NAME    variable   estimate   moe
##    <chr> <chr>   <chr>         <dbl> <dbl>
##  1 01    Alabama B19001_001  1852518 12189
##  2 01    Alabama B19001_002   176641  6328
##  3 01    Alabama B19001_003   120590  5347
##  4 01    Alabama B19001_004   117332  5956
##  5 01    Alabama B19001_005   108912  5308
##  6 01    Alabama B19001_006   102080  4740
##  7 01    Alabama B19001_007   103366  5246
##  8 01    Alabama B19001_008    91011  4699
##  9 01    Alabama B19001_009    86996  4418
## 10 01    Alabama B19001_010    74864  4210
## # … with 874 more rows
```

In this example, each row represents state-characteristic combinations, consistent with the tidy data model. Alternatively, if a user desires the variables spread across the columns of the dataset, the setting `output = "wide"` will enable this. For ACS data, estimates and margins of error for each ACS variable will be found in their own columns. For example:


```r
hhinc_wide <- get_acs(
  geography = "state", 
  table = "B19001", 
  survey = "acs1", 
  year = 2016,
  output = "wide"
)

hhinc_wide
```

```
## # A tibble: 52 x 36
##    GEOID NAME        B19001_001E B19001_001M B19001_002E B19001_002M B19001_003E
##    <chr> <chr>             <dbl>       <dbl>       <dbl>       <dbl>       <dbl>
##  1 28    Mississippi     1091245        8803      113124        4835       87136
##  2 29    Missouri        2372190       10844      160615        6705      122649
##  3 30    Montana          416125        4426       26734        2183       24786
##  4 31    Nebraska         747562        4452       45794        3116       33266
##  5 32    Nevada          1055158        6433       68507        4886       42720
##  6 33    New Hampsh…      520643        5191       20890        2566       15933
##  7 34    New Jersey      3194519       10274      170029        6836      118862
##  8 35    New Mexico       758364        6296       66983        4439       48930
##  9 36    New York        7209054       17665      543763       12132      352029
## 10 37    North Caro…     3882423       16063      282491        7816      228088
## # … with 42 more rows, and 29 more variables: B19001_003M <dbl>,
## #   B19001_004E <dbl>, B19001_004M <dbl>, B19001_005E <dbl>, B19001_005M <dbl>,
## #   B19001_006E <dbl>, B19001_006M <dbl>, B19001_007E <dbl>, B19001_007M <dbl>,
## #   B19001_008E <dbl>, B19001_008M <dbl>, B19001_009E <dbl>, B19001_009M <dbl>,
## #   B19001_010E <dbl>, B19001_010M <dbl>, B19001_011E <dbl>, B19001_011M <dbl>,
## #   B19001_012E <dbl>, B19001_012M <dbl>, B19001_013E <dbl>, B19001_013M <dbl>,
## #   B19001_014E <dbl>, B19001_014M <dbl>, B19001_015E <dbl>, B19001_015M <dbl>,
## #   B19001_016E <dbl>, B19001_016M <dbl>, B19001_017E <dbl>, B19001_017M <dbl>
```

The wide-form dataset includes `GEOID` and `NAME` columns, as in the tidy dataset, but is also characterized by estimate/margin of error pairs across the columns for each Census variable in the table.

### Renaming variable IDs

Census variables IDs can be cumbersome to type and remember in the course of an R session. As such, tidycensus has built-in tools to automatically rename the variable IDs if requested by a user. For example, let's say that a user is requesting data on median household income (variable ID `B19013_001`) and median age (variable ID `B01002_001`). By passing a *named* vector to the `variables` parameter in `get_acs()` or `get_decennial()`, the functions will return the desired names rather than the Census variable IDs. Let's examine this for counties in Georgia from the 2015-2019 five-year ACS.


```r
ga <- get_acs(
  geography = "county",
  state = "Georgia",
  variables = c(medinc = "B19013_001",
                medage = "B01002_001"),
  year = 2019
)

ga
```

```
## # A tibble: 318 x 5
##    GEOID NAME                     variable estimate    moe
##    <chr> <chr>                    <chr>       <dbl>  <dbl>
##  1 13001 Appling County, Georgia  medage       40.3    1.4
##  2 13001 Appling County, Georgia  medinc    40304   5180  
##  3 13003 Atkinson County, Georgia medage       36.4    1  
##  4 13003 Atkinson County, Georgia medinc    37197   3686  
##  5 13005 Bacon County, Georgia    medage       36.7    0.7
##  6 13005 Bacon County, Georgia    medinc    37519   5492  
##  7 13007 Baker County, Georgia    medage       46.1    5.5
##  8 13007 Baker County, Georgia    medinc    32917   6967  
##  9 13009 Baldwin County, Georgia  medage       35.5    0.3
## 10 13009 Baldwin County, Georgia  medinc    43672   3736  
## # … with 308 more rows
```

ACS variable IDs, which would be found in the `variable` column, are replaced by `medage` and `medinc`, as requested. When a wide-form dataset is requested, tidycensus will still append `E` and `M` to the specified column names, as illustrated below.


```r
ga_wide <- get_acs(
  geography = "county",
  state = "Georgia",
  variables = c(medinc = "B19013_001",
                medage = "B01002_001"),
  output = "wide"
)

ga_wide
```

```
## # A tibble: 159 x 6
##    GEOID NAME                          medincE medincM medageE medageM
##    <chr> <chr>                           <dbl>   <dbl>   <dbl>   <dbl>
##  1 13005 Bacon County, Georgia           37519    5492    36.7     0.7
##  2 13025 Brantley County, Georgia        38857    3480    41.1     0.8
##  3 13017 Ben Hill County, Georgia        32229    3845    39.9     1.1
##  4 13033 Burke County, Georgia           44151    2438    37.4     0.6
##  5 13047 Catoosa County, Georgia         56235    2290    40.4     0.4
##  6 13053 Chattahoochee County, Georgia   47096    5158    24.5     0.5
##  7 13055 Chattooga County, Georgia       36807    2268    39.4     0.7
##  8 13073 Columbia County, Georgia        82339    3532    36.9     0.4
##  9 13087 Decatur County, Georgia         41481    3584    37.8     0.6
## 10 13115 Floyd County, Georgia           48336    2266    38.3     0.3
## # … with 149 more rows
```

Median household income for each county is represented by `medincE`, for the estimate, and `medincM`, for the margin of error. At the time of this writing, custom variable names are only available for `variables` and not for `table`, as users will not always know the number of variables found in a table beforehand.

## Other Census Bureau datasets in tidycensus

As mentioned earlier in this chapter, tidycensus does not grant access to all of the datasets available from the Census API; users should look at the censusapi package for that functionality. However, the Population Estimates and ACS Migration Flows APIs are accessible with the `get_estimates()` and `get_flows()` functions, respectively. This section includes brief examples of each.

### Using `get_estimates()`

The Population Estimates Program, or PEP, provides yearly estimates of the US population and its components between decennial Censuses. It differs from the ACS in that it is not directly based on a dedicated survey, but rather based on population projections since the most recent decennial Census based on birth, death, and migration rates.

One advantage of using the PEP to retrieve data is that allows you to access the indicators used to produce the intercensal population estimates. These indicators can be specified as variables direction in the `get_estimates()` function in tidycensus, or requested in bulk by using the `product` argument. The products available include `"population"`, `"components"`, `"housing"`, and `"characteristics"`. For example, we can request all components of change population estimates for 2019 for a specific county:


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

queens_components
```

```
## # A tibble: 12 x 4
##    NAME                    GEOID variable              value
##    <chr>                   <chr> <chr>                 <dbl>
##  1 Queens County, New York 36081 BIRTHS             27453   
##  2 Queens County, New York 36081 DEATHS             16380   
##  3 Queens County, New York 36081 DOMESTICMIG       -41789   
##  4 Queens County, New York 36081 INTERNATIONALMIG    9883   
##  5 Queens County, New York 36081 NATURALINC         11073   
##  6 Queens County, New York 36081 NETMIG            -31906   
##  7 Queens County, New York 36081 RBIRTH                12.1 
##  8 Queens County, New York 36081 RDEATH                 7.23
##  9 Queens County, New York 36081 RDOMESTICMIG         -18.5 
## 10 Queens County, New York 36081 RINTERNATIONALMIG      4.36
## 11 Queens County, New York 36081 RNATURALINC            4.89
## 12 Queens County, New York 36081 RNETMIG              -14.1
```

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

louisiana_age_hisp
```

```
## # A tibble: 9 x 5
##   GEOID NAME        value SEX        HISP                 
##   <chr> <chr>       <dbl> <chr>      <chr>                
## 1 22    Louisiana 4648794 Both sexes Both Hispanic Origins
## 2 22    Louisiana 4401822 Both sexes Non-Hispanic         
## 3 22    Louisiana  246972 Both sexes Hispanic             
## 4 22    Louisiana 2267050 Male       Both Hispanic Origins
## 5 22    Louisiana 2135979 Male       Non-Hispanic         
## 6 22    Louisiana  131071 Male       Hispanic             
## 7 22    Louisiana 2381744 Female     Both Hispanic Origins
## 8 22    Louisiana 2265843 Female     Non-Hispanic         
## 9 22    Louisiana  115901 Female     Hispanic
```

### Using `get_flows()`

As of version 1.0, tidycensus also includes support for the ACS Migration Flows API. The flows API returns information on both in- and out-migration for states, counties, and metropolitan areas. By default, the function allows for analysis of in-migrants, emigrants, and net migration for a given geography using data from a given 5-year ACS sample. In the example below, we request migration data for Honolulu County, Hawaii. In-migration for world regions is available along with out-migration and net migration for US locations.


```r
honolulu_migration <- get_flows(
  geography = "county",
  state = "HI",
  county = "Honolulu",
  year = 2018,
  show_call = TRUE
)

honolulu_migration
```

```
## # A tibble: 3,252 x 7
##    GEOID1 GEOID2 FULL1_NAME              FULL2_NAME      variable estimate   moe
##    <chr>  <chr>  <chr>                   <chr>           <chr>       <dbl> <dbl>
##  1 15003  <NA>   Honolulu County, Hawaii Africa          MOVEDIN        86    70
##  2 15003  <NA>   Honolulu County, Hawaii Africa          MOVEDOUT       NA    NA
##  3 15003  <NA>   Honolulu County, Hawaii Africa          MOVEDNET       NA    NA
##  4 15003  <NA>   Honolulu County, Hawaii Asia            MOVEDIN      7620   891
##  5 15003  <NA>   Honolulu County, Hawaii Asia            MOVEDOUT       NA    NA
##  6 15003  <NA>   Honolulu County, Hawaii Asia            MOVEDNET       NA    NA
##  7 15003  <NA>   Honolulu County, Hawaii Central America MOVEDIN       228    98
##  8 15003  <NA>   Honolulu County, Hawaii Central America MOVEDOUT       NA    NA
##  9 15003  <NA>   Honolulu County, Hawaii Central America MOVEDNET       NA    NA
## 10 15003  <NA>   Honolulu County, Hawaii Caribbean       MOVEDIN       106    94
## # … with 3,242 more rows
```

`get_flows()` also includes functionality for migration flow mapping; this advanced feature will be covered in Chapter \@ref(6) of this book.

## Exercises

1.  Review the available geographies in tidycensus from the geography table in this chapter. Acquire data on median age (variable `B01002_001`) for a geography we have not yet used.

2.  Use the `load_variables()` function to find a variable that interests you that we haven't used yet. Use `get_acs()` to fetch data from the 2015-2019 ACS for counties in the state where you live, where you have visited, or where you would like to visit.
