# Wrangling Census data with tidyverse tools



One of the most popular frameworks for data analysis in R is the **tidyverse**, a suite of packages designed for integrated data wrangling, visualization, and modeling. The "tidy" or long-form data returned by default in **tidycensus** is designed to work well with tidyverse analytic workflows. This chapter provides an overview of how to use tidyverse tools to gain additional insights about US Census data retrieved with **tidycensus**. It concludes with discussion about margins of error (MOEs) in the American Community Survey and how to wrangle and interpret MOEs appropriately.

## The tidyverse

[The tidyverse](https://www.tidyverse.org/) is a collection of R packages that are designed to work together in common data wrangling, analysis, and visualization projects. Many of these R packages, maintained by RStudio, are among the most popular R packages worldwide. Some of the key packages you'll use in the tidyverse include:

-   **readr** [@wickham2021_readr], which contains tools for importing and exporting datasets;

-   **dplyr** [@wickham2021_dplyr], a powerful framework for data wrangling tasks;

-   **tidyr** [@wickham2021_tidyr], a package for reshaping data;

-   **purrr** [@henry2020_purrr], a comprehensive framework for functional programming and iteration;

-   **ggplot2** [@wickham2016], a data visualization package based on the Grammar of Graphics

The core data structure used in the tidyverse is the *tibble*, which is an R data frame with some small enhancements to improve the user experience. **tidycensus** returns tibbles by default.

A full treatment of the tidyverse and its functionality is beyond the scope of this book; however, the examples in this chapter will introduce you to several key tidyverse features using US Census Bureau data. For a more general and broader treatment of the tidyverse, I recommend the *R for Data Science* book [@r4ds].

## Exploring Census data with tidyverse tools

Census data queries using **tidycensus**, combined with core tidyverse functions, are excellent ways to explore downloaded Census data. Chapter \@ref(an-introduction-to-tidycensus) covered how to download data from various Census datasets using **tidycensus** and return the data in a desired format. A common next step in an analytic process will involve data exploration, which is handled by a wide range of tools in the tidyverse.

To get started, the **tidycensus** and **tidyverse** packages are loaded. "tidyverse" is not specifically a package itself, but rather loads several core packages within the tidyverse. The package load message gives you more information:


```r
library(tidycensus)
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
```

```
## ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
## ✓ tibble  3.1.4     ✓ dplyr   1.0.7
## ✓ tidyr   1.1.3     ✓ stringr 1.4.0
## ✓ readr   2.0.0     ✓ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

Eight tidyverse packages are loaded: **ggplot2**, **tibble** [@muller2021_tibble], **purrr**, **dplyr**, **readr**, and **tidyr** are included along with **stringr** [@wickham2019_stringr] for string manipulation and **forcats** [@wickham2021_forcats] for working with factors. These tools collectively can be used for many core Census data analysis tasks.

### Sorting and filtering data

For a first example, let's request data on median age from the 2015-2019 ACS with `get_acs()` for all counties in the United States. This requires specifying `geography = "county"` and leaving state set to `NULL`, the default.


```r
median_age <- get_acs(
  geography = "county",
  variables = "B01002_001",
  year = 2019
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:median-age-show)Median age for US counties</caption>
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
   <td style="text-align:left;"> 01001 </td>
   <td style="text-align:left;"> Autauga County, Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 38.2 </td>
   <td style="text-align:right;"> 0.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01003 </td>
   <td style="text-align:left;"> Baldwin County, Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 43.0 </td>
   <td style="text-align:right;"> 0.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01005 </td>
   <td style="text-align:left;"> Barbour County, Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 40.4 </td>
   <td style="text-align:right;"> 0.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01007 </td>
   <td style="text-align:left;"> Bibb County, Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 40.9 </td>
   <td style="text-align:right;"> 1.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01009 </td>
   <td style="text-align:left;"> Blount County, Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 40.7 </td>
   <td style="text-align:right;"> 0.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01011 </td>
   <td style="text-align:left;"> Bullock County, Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 40.2 </td>
   <td style="text-align:right;"> 2.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01013 </td>
   <td style="text-align:left;"> Butler County, Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 40.8 </td>
   <td style="text-align:right;"> 0.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01015 </td>
   <td style="text-align:left;"> Calhoun County, Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 39.6 </td>
   <td style="text-align:right;"> 0.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01017 </td>
   <td style="text-align:left;"> Chambers County, Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 42.0 </td>
   <td style="text-align:right;"> 0.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01019 </td>
   <td style="text-align:left;"> Cherokee County, Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 46.5 </td>
   <td style="text-align:right;"> 0.5 </td>
  </tr>
</tbody>
</table>

The default method for printing data used by the **tibble** package shows the first 10 rows of the dataset, which in this case prints counties in Alabama. A first exploratory data analysis question might involve understanding which counties are the *youngest* and *oldest* in the United States as measured by median age. This task can be accomplished with the `arrange()` function found in the **dplyr** package. `arrange()` sorts a dataset by values in one or more columns and returns the sorted result. To view the dataset in ascending order of a given column, supply the data object and a column name to the `arrange()` function.


```r
arrange(median_age, estimate)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:youngest-counties-show)The youngest counties in the US by median age</caption>
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
   <td style="text-align:left;"> 51678 </td>
   <td style="text-align:left;"> Lexington city, Virginia </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 22.3 </td>
   <td style="text-align:right;"> 0.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 51750 </td>
   <td style="text-align:left;"> Radford city, Virginia </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 23.4 </td>
   <td style="text-align:right;"> 0.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 16065 </td>
   <td style="text-align:left;"> Madison County, Idaho </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 23.5 </td>
   <td style="text-align:right;"> 0.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46121 </td>
   <td style="text-align:left;"> Todd County, South Dakota </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 23.8 </td>
   <td style="text-align:right;"> 0.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 02158 </td>
   <td style="text-align:left;"> Kusilvak Census Area, Alaska </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 24.1 </td>
   <td style="text-align:right;"> 0.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 13053 </td>
   <td style="text-align:left;"> Chattahoochee County, Georgia </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 24.5 </td>
   <td style="text-align:right;"> 0.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 53075 </td>
   <td style="text-align:left;"> Whitman County, Washington </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 24.7 </td>
   <td style="text-align:right;"> 0.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49049 </td>
   <td style="text-align:left;"> Utah County, Utah </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 24.8 </td>
   <td style="text-align:right;"> 0.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46027 </td>
   <td style="text-align:left;"> Clay County, South Dakota </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 24.9 </td>
   <td style="text-align:right;"> 0.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 51830 </td>
   <td style="text-align:left;"> Williamsburg city, Virginia </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 24.9 </td>
   <td style="text-align:right;"> 0.7 </td>
  </tr>
</tbody>
</table>

Per the 2015-2019 ACS, the two youngest "counties" in the United States are independent cities in Virginia, which are treated as county-equivalents. Both Lexington and Radford are college towns; Lexington is home to both Washington & Lee University and the Virginia Military Institute, and Radford houses Radford University. The youngest *county* then by median age is Madison County, Idaho.

To retrieve the *oldest* counties in the United States by median age, an analyst can use the `desc()` function available in **dplyr** to sort the `estimate` column in descending order.


```r
arrange(median_age, desc(estimate))
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:oldest-counties-show)The oldest counties in the US by median age</caption>
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
   <td style="text-align:left;"> 12119 </td>
   <td style="text-align:left;"> Sumter County, Florida </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 67.4 </td>
   <td style="text-align:right;"> 0.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 51091 </td>
   <td style="text-align:left;"> Highland County, Virginia </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 60.9 </td>
   <td style="text-align:right;"> 3.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 08027 </td>
   <td style="text-align:left;"> Custer County, Colorado </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 59.7 </td>
   <td style="text-align:right;"> 2.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 12015 </td>
   <td style="text-align:left;"> Charlotte County, Florida </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 59.1 </td>
   <td style="text-align:right;"> 0.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 41069 </td>
   <td style="text-align:left;"> Wheeler County, Oregon </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 59.0 </td>
   <td style="text-align:right;"> 3.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 51133 </td>
   <td style="text-align:left;"> Northumberland County, Virginia </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 58.9 </td>
   <td style="text-align:right;"> 0.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 26131 </td>
   <td style="text-align:left;"> Ontonagon County, Michigan </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 58.6 </td>
   <td style="text-align:right;"> 0.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 35021 </td>
   <td style="text-align:left;"> Harding County, New Mexico </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 58.5 </td>
   <td style="text-align:right;"> 5.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 53031 </td>
   <td style="text-align:left;"> Jefferson County, Washington </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 58.3 </td>
   <td style="text-align:right;"> 0.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 26001 </td>
   <td style="text-align:left;"> Alcona County, Michigan </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 58.2 </td>
   <td style="text-align:right;"> 0.3 </td>
  </tr>
</tbody>
</table>

The oldest county in the United States by almost 7 years over the second-oldest is Sumter County, Florida. Sumter County is home to The Villages, a Census-designated place that includes a large age-restricted community [also called The Villages](https://www.thevillages.com/).

The tidyverse includes several tools for parsing datasets that allow for exploration beyond sorting and browsing data. The `filter()` function in **dplyr** queries a dataset for rows where a given condition evaluates to `TRUE`, and retains those rows only. For analysts who are familiar with databases and SQL, this is equivalent to a `WHERE` clause. This helps analysts subset their data for specific areas by their characteristics, and answer questions like "how many counties in the US have a median age of 50 or older?"


```r
filter(median_age, estimate >= 50)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:fifty-or-over-show)Counties with a median age of 50 or above</caption>
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
   <td style="text-align:left;"> 04007 </td>
   <td style="text-align:left;"> Gila County, Arizona </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 50.2 </td>
   <td style="text-align:right;"> 0.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04012 </td>
   <td style="text-align:left;"> La Paz County, Arizona </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 56.5 </td>
   <td style="text-align:right;"> 0.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04015 </td>
   <td style="text-align:left;"> Mohave County, Arizona </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 51.6 </td>
   <td style="text-align:right;"> 0.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04025 </td>
   <td style="text-align:left;"> Yavapai County, Arizona </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 53.4 </td>
   <td style="text-align:right;"> 0.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 05005 </td>
   <td style="text-align:left;"> Baxter County, Arkansas </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 52.2 </td>
   <td style="text-align:right;"> 0.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 05089 </td>
   <td style="text-align:left;"> Marion County, Arkansas </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 52.2 </td>
   <td style="text-align:right;"> 0.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 05097 </td>
   <td style="text-align:left;"> Montgomery County, Arkansas </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 50.4 </td>
   <td style="text-align:right;"> 0.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 05137 </td>
   <td style="text-align:left;"> Stone County, Arkansas </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 50.1 </td>
   <td style="text-align:right;"> 0.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 06003 </td>
   <td style="text-align:left;"> Alpine County, California </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 52.2 </td>
   <td style="text-align:right;"> 8.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 06005 </td>
   <td style="text-align:left;"> Amador County, California </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 50.5 </td>
   <td style="text-align:right;"> 0.4 </td>
  </tr>
</tbody>
</table>

Functions like `arrange()` and `filter()` operate on row values and organize data by row. Other tidyverse functions, like **tidyr**'s `separate()`, operate on columns. The `NAME` column, returned by default by most **tidycensus** functions, contains a basic description of the location that can be more intuitive than the `GEOID`. For the 2015-2019 ACS, `NAME` is formatted as "X County, Y", where X is the county name and Y is the state name. `separate()` can split this column into two columns where one retains the county name and the other retains the state; this can be useful for analysts who need to complete a comparative analysis by state.


```r
separate(
  median_age,
  NAME,
  into = c("county", "state"),
  sep = ", "
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:separate-show)Separate columns for county and state</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> county </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> state </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> estimate </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> moe </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 01001 </td>
   <td style="text-align:left;"> Autauga County </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 38.2 </td>
   <td style="text-align:right;"> 0.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01003 </td>
   <td style="text-align:left;"> Baldwin County </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 43.0 </td>
   <td style="text-align:right;"> 0.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01005 </td>
   <td style="text-align:left;"> Barbour County </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 40.4 </td>
   <td style="text-align:right;"> 0.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01007 </td>
   <td style="text-align:left;"> Bibb County </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 40.9 </td>
   <td style="text-align:right;"> 1.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01009 </td>
   <td style="text-align:left;"> Blount County </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 40.7 </td>
   <td style="text-align:right;"> 0.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01011 </td>
   <td style="text-align:left;"> Bullock County </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 40.2 </td>
   <td style="text-align:right;"> 2.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01013 </td>
   <td style="text-align:left;"> Butler County </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 40.8 </td>
   <td style="text-align:right;"> 0.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01015 </td>
   <td style="text-align:left;"> Calhoun County </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 39.6 </td>
   <td style="text-align:right;"> 0.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01017 </td>
   <td style="text-align:left;"> Chambers County </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 42.0 </td>
   <td style="text-align:right;"> 0.7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 01019 </td>
   <td style="text-align:left;"> Cherokee County </td>
   <td style="text-align:left;"> Alabama </td>
   <td style="text-align:left;"> B01002_001 </td>
   <td style="text-align:right;"> 46.5 </td>
   <td style="text-align:right;"> 0.5 </td>
  </tr>
</tbody>
</table>

::: {.rmdnote}
You may have noticed above that existing variable names are unquoted when referenced in tidyverse functions. Many tidyverse functions use non-standard evaluation to refer to column names, which means that column names can be used as arguments directly without quotation marks. Non-standard evaluation makes interactive programming faster, especially for beginners; however, it can introduce some complications when writing your own functions or R packages. A full treatment of non-standard evaluation is beyond the scope of this book; Hadley Wickham's *Advanced R* [@wickham2019a] is the best resource on the topic if you'd like to learn more.
:::

### Using summary variables and calculating new columns

Data in Census and ACS tables, as in the example above, are frequently comprised of variables that individually constitute sub-categories such as the numbers of households in different household income bands. One limitation of the approach above, however, is that the data - and the resulting analysis - return estimated counts, which are difficult to compare across geographies. For example, Maricopa County in Arizona is the state's most populous county with 4.3 million residents; the second-largest county, Pima, only has just over 1 million residents and six of the state's 15 counties have fewer than 100,000 residents. In turn, comparing Maricopa's estimates with those of smaller counties in the state would often be inappropriate.

A solution to this issue might involve **normalizing** the estimated count data by dividing it by the overall population from which the sub-group is derived. Appropriate denominators for ACS tables are frequently found in the tables themselves as variables. In ACS table B19001, which covers the number of households by income bands, the variable `B19001_001` represents the total number of households in a given enumeration unit, which we removed from our analysis earlier. Given that this variable is an appropriate denominator for the other variables in the table, it merits its own column to facilitate the calculation of proportions or percentages.

In **tidycensus**, this can be accomplished by supplying a variable ID to the `summary_var` parameter in both the `get_acs()` and `get_decennial()` functions. Doing so will create two new columns for the decennial Census datasets - `summary_var` and `summary_value`, representing the summary variable ID and the summary variable's value - and three new columns for the ACS datasets, `summary_var`, `summary_est`, and `summary_moe`, which includes the ACS estimate and margin of error for the summary variable.

With this information in hand, normalizing data is straightforward. The following example uses the `summary_var` parameter to compare the population of counties in Arizona by race & Hispanic origin with their baseline populations, using data from the 2015-2019 ACS.


```r
race_vars <- c(
  White = "B03002_003",
  Black = "B03002_004",
  Native = "B03002_005",
  Asian = "B03002_006",
  HIPI = "B03002_007",
  Hispanic = "B03002_012"
)

az_race <- get_acs(
  geography = "county",
  state = "AZ",
  variables = race_vars,
  summary_var = "B03002_001"
) 
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:az-race-show)Race and ethnicity in Arizona</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> estimate </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> moe </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> summary_est </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> summary_moe </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 04001 </td>
   <td style="text-align:left;"> Apache County, Arizona </td>
   <td style="text-align:left;"> White </td>
   <td style="text-align:right;"> 13022 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 71511 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04001 </td>
   <td style="text-align:left;"> Apache County, Arizona </td>
   <td style="text-align:left;"> Black </td>
   <td style="text-align:right;"> 373 </td>
   <td style="text-align:right;"> 138 </td>
   <td style="text-align:right;"> 71511 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04001 </td>
   <td style="text-align:left;"> Apache County, Arizona </td>
   <td style="text-align:left;"> Native </td>
   <td style="text-align:right;"> 52285 </td>
   <td style="text-align:right;"> 234 </td>
   <td style="text-align:right;"> 71511 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04001 </td>
   <td style="text-align:left;"> Apache County, Arizona </td>
   <td style="text-align:left;"> Asian </td>
   <td style="text-align:right;"> 246 </td>
   <td style="text-align:right;"> 78 </td>
   <td style="text-align:right;"> 71511 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04001 </td>
   <td style="text-align:left;"> Apache County, Arizona </td>
   <td style="text-align:left;"> HIPI </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 71511 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04001 </td>
   <td style="text-align:left;"> Apache County, Arizona </td>
   <td style="text-align:left;"> Hispanic </td>
   <td style="text-align:right;"> 4531 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 71511 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04003 </td>
   <td style="text-align:left;"> Cochise County, Arizona </td>
   <td style="text-align:left;"> White </td>
   <td style="text-align:right;"> 69216 </td>
   <td style="text-align:right;"> 235 </td>
   <td style="text-align:right;"> 125867 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04003 </td>
   <td style="text-align:left;"> Cochise County, Arizona </td>
   <td style="text-align:left;"> Black </td>
   <td style="text-align:right;"> 4620 </td>
   <td style="text-align:right;"> 247 </td>
   <td style="text-align:right;"> 125867 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04003 </td>
   <td style="text-align:left;"> Cochise County, Arizona </td>
   <td style="text-align:left;"> Native </td>
   <td style="text-align:right;"> 1142 </td>
   <td style="text-align:right;"> 191 </td>
   <td style="text-align:right;"> 125867 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 04003 </td>
   <td style="text-align:left;"> Cochise County, Arizona </td>
   <td style="text-align:left;"> Asian </td>
   <td style="text-align:right;"> 2431 </td>
   <td style="text-align:right;"> 162 </td>
   <td style="text-align:right;"> 125867 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
</tbody>
</table>

By using dplyr's `mutate()` function, we calculate a new column, `percent`, representing the percentage of each Census tract's population that corresponds to each racial/ethnic group in 2015-2019. The `select()` function, also in dplyr, retains only those columns that we need to view.


```r
az_race_percent <- az_race %>%
  mutate(percent = 100 * (estimate / summary_est)) %>%
  select(NAME, variable, percent)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:az-race-percent-show)Race and ethnicity in Arizona as percentages</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> percent </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Apache County, Arizona </td>
   <td style="text-align:left;"> White </td>
   <td style="text-align:right;"> 18.2097859 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Apache County, Arizona </td>
   <td style="text-align:left;"> Black </td>
   <td style="text-align:right;"> 0.5215981 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Apache County, Arizona </td>
   <td style="text-align:left;"> Native </td>
   <td style="text-align:right;"> 73.1146257 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Apache County, Arizona </td>
   <td style="text-align:left;"> Asian </td>
   <td style="text-align:right;"> 0.3440030 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Apache County, Arizona </td>
   <td style="text-align:left;"> HIPI </td>
   <td style="text-align:right;"> 0.0223742 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Apache County, Arizona </td>
   <td style="text-align:left;"> Hispanic </td>
   <td style="text-align:right;"> 6.3360882 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Cochise County, Arizona </td>
   <td style="text-align:left;"> White </td>
   <td style="text-align:right;"> 54.9913798 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Cochise County, Arizona </td>
   <td style="text-align:left;"> Black </td>
   <td style="text-align:right;"> 3.6705411 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Cochise County, Arizona </td>
   <td style="text-align:left;"> Native </td>
   <td style="text-align:right;"> 0.9073069 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Cochise County, Arizona </td>
   <td style="text-align:left;"> Asian </td>
   <td style="text-align:right;"> 1.9314038 </td>
  </tr>
</tbody>
</table>

The above example introduces some additional syntax common to tidyverse data analyses. The `%>%` operator from the **magrittr** R package [@bache_2020] is a *pipe* operator that allows for analysts to develop *analytic pipelines*, which are deeply embedded in tidyverse-centric data analytic workflows. The pipe operator passes the result of a given line of code as the first argument of the code on the next line. In turn, analysts can develop data analysis pipelines of related operations that fit together in a coherent way.

tidyverse developers recommend that the pipe operator be read as "then". The above code can in turn be interpreted as "Create a new data object `az_race_percent` by using the existing data object `az_race` THEN creating a new `percent` column THEN selecting the `NAME`, `variable`, and `percent` columns."

Since R version 4.1, the base installation of R also includes a pipe operator, `|>`. It works much the same way as the **magrittr** pipe `%>%`, though `%>%` has some small additional features that make it work well within tidyverse analysis pipelines. In turn, `%>%` will be used in the examples throughout this book.

## Group-wise Census data analysis

The split-apply-combine model of data analysis, as discussed in @wickham2011, is a powerful framework for analyzing demographic data. In general terms, an analyst will apply this framework as follows:

-   The analyst identifies salient groups in a dataset between which they want to make comparisons. The dataset is then **split** into multiple pieces, one for each group.

-   A function is then **applied** to each group in turn. This might be a simple summary function, such as taking the maximum or calculating the mean, or a custom function defined by the analyst.

-   Finally, the results of the function applied to each group are **combined** back into a single dataset, allowing the analyst to compare the results by group.

Given the hierarchical nature of US Census Bureau data, "groups" across which analysts can make comparisons are found in just about every analytic tasks. In many cases, the split-apply-combine model of data analysis will be useful to analysts as they make sense of patterns and trends found in Census data.

In the tidyverse, split-apply-combine is implemented with the `group_by()` function in the dplyr package. `group_by()` does the work for the analyst of splitting a dataset into groups, allowing subsequent functions used by the analyst in an analytic pipeline to be applied to each group then combined back into a single dataset. The examples that follow illustrate some common group-wise analyses.

### Making group-wise comparisons

The `az_race_percent` dataset created above is an example of a dataset suitable for group-wise data analysis. It includes two columns that could be used as group definitions: `NAME`, representing the county, and `variable`, representing the racial or ethnic group. Split-apply-combine could be used for either group definition to make comparisons for data in Arizona across these categories.

In a first example, we can deploy group-wise data analysis to identify the largest racial or ethnic group in each county in Arizona. This involves setting up a data analysis pipeline with the **magrittr** pipe and calculating a *grouped filter* where the `filter()` operation will be applied specific to each group. In this example, the filter condition will be specified as `percent == max(percent)`. We can read the analytic pipeline then as "Create a new dataset, `largest_group`, by using the `az_race_dataset` THEN grouping the dataset by the `NAME` column THEN filtering for rows that are equal to the maximum value of `percent` for each group."


```r
largest_group <- az_race_percent %>%
  group_by(NAME) %>%
  filter(percent == max(percent))
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:largest-group-show)Largest group by county in Arizona</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> percent </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Apache County, Arizona </td>
   <td style="text-align:left;"> Native </td>
   <td style="text-align:right;"> 73.11463 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Cochise County, Arizona </td>
   <td style="text-align:left;"> White </td>
   <td style="text-align:right;"> 54.99138 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Coconino County, Arizona </td>
   <td style="text-align:left;"> White </td>
   <td style="text-align:right;"> 54.05170 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gila County, Arizona </td>
   <td style="text-align:left;"> White </td>
   <td style="text-align:right;"> 62.25302 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Graham County, Arizona </td>
   <td style="text-align:left;"> White </td>
   <td style="text-align:right;"> 50.85799 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Greenlee County, Arizona </td>
   <td style="text-align:left;"> Hispanic </td>
   <td style="text-align:right;"> 46.79689 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> La Paz County, Arizona </td>
   <td style="text-align:left;"> White </td>
   <td style="text-align:right;"> 57.39912 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Maricopa County, Arizona </td>
   <td style="text-align:left;"> White </td>
   <td style="text-align:right;"> 55.24102 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Mohave County, Arizona </td>
   <td style="text-align:left;"> White </td>
   <td style="text-align:right;"> 77.29074 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Navajo County, Arizona </td>
   <td style="text-align:left;"> Native </td>
   <td style="text-align:right;"> 43.52613 </td>
  </tr>
</tbody>
</table>

The result of the grouped filter allows us to review the most common racial or ethnic group in each Arizona County along with how their percentages vary. For example, in two Arizona counties (Greenlee and Navajo), none of the racial or ethnic groups form a majority of the population.

`group_by()` is commonly paired with the `summarize()` function in data analysis pipelines. `summarize()` generates a new, condensed dataset that by default returns a column for the grouping variable(s) and columns representing the results of one or more functions applied to those groups. In the example below, the `median()` function is used to identify the median percentage for each of the racial & ethnic groups in the dataset across counties in Arizona. In turn, `variable` is passed to `group_by()` as the grouping variable.


```r
az_race_percent %>%
  group_by(variable) %>%
  summarize(median_pct = median(percent))
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:median-by-group-show)Median percentage by group</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> median_pct </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Asian </td>
   <td style="text-align:right;"> 0.9238513 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Black </td>
   <td style="text-align:right;"> 1.1155627 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HIPI </td>
   <td style="text-align:right;"> 0.1210654 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hispanic </td>
   <td style="text-align:right;"> 30.1555247 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Native </td>
   <td style="text-align:right;"> 3.5811804 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> White </td>
   <td style="text-align:right;"> 54.0517009 </td>
  </tr>
</tbody>
</table>

The result of this operation tells us the median county percentage of each racial and ethnic group for the state of Arizona. A broader analysis might involve the calculation of these percentages hierarchically, finding the median county percentage of given attributes across states, for example.

### Tabulating new groups

In the examples above, suitable groups in the `NAME` and `variable` columns were already found in the data retrieved with `get_acs()`. Commonly, analysts will also need to calculate new custom groups to address specific analytic questions. For example, variables in ACS table B19001 represent groups of households whose household incomes fall into a variety of categories: less than \$10,000/year, between \$10,000/year and \$19,999/year, and so forth. These categories may be more granular than needed by an analyst. As such, an analyst might take the following steps: 1) recode the ACS variables into wider income bands; 2) group the data by the wider income bands; 3) calculate grouped sums to generate new estimates.

Consider the following example, using household income data for Minnesota counties from the 2012-2016 ACS:


```r
mn_hh_income <- get_acs(
  geography = "county",
  table = "B19001",
  state = "MN",
  year = 2016
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:mn-hh-income-show)Table B19001 for counties in Minnesota</caption>
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
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_001 </td>
   <td style="text-align:right;"> 7640 </td>
   <td style="text-align:right;"> 262 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_002 </td>
   <td style="text-align:right;"> 562 </td>
   <td style="text-align:right;"> 77 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_003 </td>
   <td style="text-align:right;"> 544 </td>
   <td style="text-align:right;"> 72 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_004 </td>
   <td style="text-align:right;"> 472 </td>
   <td style="text-align:right;"> 69 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_005 </td>
   <td style="text-align:right;"> 508 </td>
   <td style="text-align:right;"> 68 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_006 </td>
   <td style="text-align:right;"> 522 </td>
   <td style="text-align:right;"> 92 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_007 </td>
   <td style="text-align:right;"> 447 </td>
   <td style="text-align:right;"> 61 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_008 </td>
   <td style="text-align:right;"> 390 </td>
   <td style="text-align:right;"> 49 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_009 </td>
   <td style="text-align:right;"> 426 </td>
   <td style="text-align:right;"> 64 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_010 </td>
   <td style="text-align:right;"> 415 </td>
   <td style="text-align:right;"> 65 </td>
  </tr>
</tbody>
</table>

Our data include household income categories for each county in the rows. However, let's say we only need three income categories for purposes of analysis: below \$35,000/year, between \$35,000/year and \$75,000/year, and \$75,000/year and up.

We first need to do some transformation of our data to recode the variables appropriately. First, we will remove variable `B19001_001`, which represents the total number of households for each county. Second, we use the `case_when()` function from the **dplyr** package to identify groups of variables that correspond to our desired groupings. Given that the variables are ordered in the ACS table in relationship to the household income values, the less than operator can be used to identify groups.

The syntax of `case_when()` can appear complex to beginners, so it is worth stepping through how the function works. Inside the `mutate()` function, which is used to create a new variable named `incgroup`, `case_when()` steps through a series of logical conditions that are evaluated in order similar to a series of if/else statements. The first condition is evaluated, telling the function to assign the value of `below35k` to all rows with a `variable` value that comes before `"B19001_008"` - which in this case will be `B19001_002` (income less than \$10,000) through `B19001_007` (income between \$30,000 and \$34,999). The second condition is then evaluated *for all those rows not accounted for by the first condition*. This means that `case_when()` knows not to assign `"bw35kand75k"` to the income group of \$10,000 and below even though its variable comes before `B19001_013`. The final condition in `case_when()` can be set to `TRUE` which in this scenario translates as "all other values."


```r
mn_hh_income_recode <- mn_hh_income %>%
  filter(variable != "B19001_001") %>%
  mutate(incgroup = case_when(
    variable < "B19001_008" ~ "below35k", 
    variable < "B19001_013" ~ "bw35kand75k", 
    TRUE ~ "above75k"
  )) 
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:mn-recode-show)Recoded household income categories</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> estimate </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> moe </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> incgroup </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_002 </td>
   <td style="text-align:right;"> 562 </td>
   <td style="text-align:right;"> 77 </td>
   <td style="text-align:left;"> below35k </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_003 </td>
   <td style="text-align:right;"> 544 </td>
   <td style="text-align:right;"> 72 </td>
   <td style="text-align:left;"> below35k </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_004 </td>
   <td style="text-align:right;"> 472 </td>
   <td style="text-align:right;"> 69 </td>
   <td style="text-align:left;"> below35k </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_005 </td>
   <td style="text-align:right;"> 508 </td>
   <td style="text-align:right;"> 68 </td>
   <td style="text-align:left;"> below35k </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_006 </td>
   <td style="text-align:right;"> 522 </td>
   <td style="text-align:right;"> 92 </td>
   <td style="text-align:left;"> below35k </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_007 </td>
   <td style="text-align:right;"> 447 </td>
   <td style="text-align:right;"> 61 </td>
   <td style="text-align:left;"> below35k </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_008 </td>
   <td style="text-align:right;"> 390 </td>
   <td style="text-align:right;"> 49 </td>
   <td style="text-align:left;"> bw35kand75k </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_009 </td>
   <td style="text-align:right;"> 426 </td>
   <td style="text-align:right;"> 64 </td>
   <td style="text-align:left;"> bw35kand75k </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_010 </td>
   <td style="text-align:right;"> 415 </td>
   <td style="text-align:right;"> 65 </td>
   <td style="text-align:left;"> bw35kand75k </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> Aitkin County, Minnesota </td>
   <td style="text-align:left;"> B19001_011 </td>
   <td style="text-align:right;"> 706 </td>
   <td style="text-align:right;"> 81 </td>
   <td style="text-align:left;"> bw35kand75k </td>
  </tr>
</tbody>
</table>

Our result illustrates how the different variable IDs are mapped to the new, recoded categories that we specified in `case_when()`. The `group_by() %>% summarize()` workflow can now be applied to the recoded categories by county to tabulate the data into a smaller number of groups.


```r
mn_group_sums <- mn_hh_income_recode %>%
  group_by(GEOID, incgroup) %>%
  summarize(estimate = sum(estimate))
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:mn-group-sums-show)Grouped sums by income bands</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> incgroup </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> estimate </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> above75k </td>
   <td style="text-align:right;"> 1706 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> below35k </td>
   <td style="text-align:right;"> 3055 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27001 </td>
   <td style="text-align:left;"> bw35kand75k </td>
   <td style="text-align:right;"> 2879 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27003 </td>
   <td style="text-align:left;"> above75k </td>
   <td style="text-align:right;"> 61403 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27003 </td>
   <td style="text-align:left;"> below35k </td>
   <td style="text-align:right;"> 24546 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27003 </td>
   <td style="text-align:left;"> bw35kand75k </td>
   <td style="text-align:right;"> 39311 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27005 </td>
   <td style="text-align:left;"> above75k </td>
   <td style="text-align:right;"> 4390 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27005 </td>
   <td style="text-align:left;"> below35k </td>
   <td style="text-align:right;"> 4528 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27005 </td>
   <td style="text-align:left;"> bw35kand75k </td>
   <td style="text-align:right;"> 4577 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 27007 </td>
   <td style="text-align:left;"> above75k </td>
   <td style="text-align:right;"> 4491 </td>
  </tr>
</tbody>
</table>

Our data now reflect the new estimates by group by county.

## Comparing ACS estimates over time

A common task when working with Census data is to examine demographic change over time. Data from the Census API - and consequently **tidycensus** - only go back to the 2000 Decennial Census. For historical analysts who want to go even further back, decennial Census data are available since 1790 from the [National Historical Geographic Information System](https://www.nhgis.org/), or NHGIS, which will be covered in detail in Chapter \@ref(other-census-and-government-data-resources).

### Time-series analysis: some cautions

Before engaging in any sort of time series analysis of Census data, analysts need to account for potential problems that can emerge when using Census data longitudinally. One major issue that can emerge is *geography changes* over time. For example, let's say we are interested in analyzing data on Oglala Lakota County, South Dakota. We can get recent data from the ACS using tools learned in Chapter \@ref(an-introduction-to-tidycensus):


```r
oglala_lakota_age <- get_acs(
  geography = "county",
  state = "SD",
  county = "Oglala Lakota",
  table = "B01001",
  year = 2019
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:oglala-lakota-show)2015-2019 age table for Oglala Lakota County, SD</caption>
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
   <td style="text-align:left;"> 46102 </td>
   <td style="text-align:left;"> Oglala Lakota County, South Dakota </td>
   <td style="text-align:left;"> B01001_001 </td>
   <td style="text-align:right;"> 14335 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46102 </td>
   <td style="text-align:left;"> Oglala Lakota County, South Dakota </td>
   <td style="text-align:left;"> B01001_002 </td>
   <td style="text-align:right;"> 7024 </td>
   <td style="text-align:right;"> 126 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46102 </td>
   <td style="text-align:left;"> Oglala Lakota County, South Dakota </td>
   <td style="text-align:left;"> B01001_003 </td>
   <td style="text-align:right;"> 771 </td>
   <td style="text-align:right;"> 58 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46102 </td>
   <td style="text-align:left;"> Oglala Lakota County, South Dakota </td>
   <td style="text-align:left;"> B01001_004 </td>
   <td style="text-align:right;"> 697 </td>
   <td style="text-align:right;"> 97 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46102 </td>
   <td style="text-align:left;"> Oglala Lakota County, South Dakota </td>
   <td style="text-align:left;"> B01001_005 </td>
   <td style="text-align:right;"> 829 </td>
   <td style="text-align:right;"> 88 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46102 </td>
   <td style="text-align:left;"> Oglala Lakota County, South Dakota </td>
   <td style="text-align:left;"> B01001_006 </td>
   <td style="text-align:right;"> 393 </td>
   <td style="text-align:right;"> 14 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46102 </td>
   <td style="text-align:left;"> Oglala Lakota County, South Dakota </td>
   <td style="text-align:left;"> B01001_007 </td>
   <td style="text-align:right;"> 263 </td>
   <td style="text-align:right;"> 41 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46102 </td>
   <td style="text-align:left;"> Oglala Lakota County, South Dakota </td>
   <td style="text-align:left;"> B01001_008 </td>
   <td style="text-align:right;"> 98 </td>
   <td style="text-align:right;"> 59 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46102 </td>
   <td style="text-align:left;"> Oglala Lakota County, South Dakota </td>
   <td style="text-align:left;"> B01001_009 </td>
   <td style="text-align:right;"> 158 </td>
   <td style="text-align:right;"> 59 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46102 </td>
   <td style="text-align:left;"> Oglala Lakota County, South Dakota </td>
   <td style="text-align:left;"> B01001_010 </td>
   <td style="text-align:right;"> 375 </td>
   <td style="text-align:right;"> 88 </td>
  </tr>
</tbody>
</table>

To understand how the age composition of the county has changed over the past 10 years, we may want to look at the 2005-2009 ACS for the county. Normally, we would just change the year argument to `2009`:


```r
oglala_lakota_age_09 <- get_acs(
  geography = "county",
  state = "SD",
  county = "Oglala Lakota",
  table = "B01001",
  year = 2009
)
```

```
## Error: Your API call has errors.  The API message returned is .
```

The request errors, and we don't get an informative error message back from the API as was discussed in Section \@ref(debugging-tidycensus-errors). The problem here is that Oglala Lakota County had a different name in 2009, Shannon County, meaning that the `county = "Oglala Lakota"` argument will not return any data. In turn, the equivalent code for the 2005-2009 ACS would use `county = "Shannon"`.


```r
oglala_lakota_age_09 <- get_acs(
  geography = "county",
  state = "SD",
  county = "Shannon",
  table = "B01001",
  year = 2009
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:shannon-county-age-show)2005-2009 age table for Oglala Lakota County, SD (then named Shannon County)</caption>
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
   <td style="text-align:left;"> 46113 </td>
   <td style="text-align:left;"> Shannon County, South Dakota </td>
   <td style="text-align:left;"> B01001_001 </td>
   <td style="text-align:right;"> 13593 </td>
   <td style="text-align:right;"> 0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46113 </td>
   <td style="text-align:left;"> Shannon County, South Dakota </td>
   <td style="text-align:left;"> B01001_002 </td>
   <td style="text-align:right;"> 6469 </td>
   <td style="text-align:right;"> 238 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46113 </td>
   <td style="text-align:left;"> Shannon County, South Dakota </td>
   <td style="text-align:left;"> B01001_003 </td>
   <td style="text-align:right;"> 739 </td>
   <td style="text-align:right;"> 99 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46113 </td>
   <td style="text-align:left;"> Shannon County, South Dakota </td>
   <td style="text-align:left;"> B01001_004 </td>
   <td style="text-align:right;"> 574 </td>
   <td style="text-align:right;"> 144 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46113 </td>
   <td style="text-align:left;"> Shannon County, South Dakota </td>
   <td style="text-align:left;"> B01001_005 </td>
   <td style="text-align:right;"> 823 </td>
   <td style="text-align:right;"> 122 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46113 </td>
   <td style="text-align:left;"> Shannon County, South Dakota </td>
   <td style="text-align:left;"> B01001_006 </td>
   <td style="text-align:right;"> 498 </td>
   <td style="text-align:right;"> 129 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46113 </td>
   <td style="text-align:left;"> Shannon County, South Dakota </td>
   <td style="text-align:left;"> B01001_007 </td>
   <td style="text-align:right;"> 291 </td>
   <td style="text-align:right;"> 39 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46113 </td>
   <td style="text-align:left;"> Shannon County, South Dakota </td>
   <td style="text-align:left;"> B01001_008 </td>
   <td style="text-align:right;"> 213 </td>
   <td style="text-align:right;"> 98 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46113 </td>
   <td style="text-align:left;"> Shannon County, South Dakota </td>
   <td style="text-align:left;"> B01001_009 </td>
   <td style="text-align:right;"> 147 </td>
   <td style="text-align:right;"> 74 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 46113 </td>
   <td style="text-align:left;"> Shannon County, South Dakota </td>
   <td style="text-align:left;"> B01001_010 </td>
   <td style="text-align:right;"> 341 </td>
   <td style="text-align:right;"> 110 </td>
  </tr>
</tbody>
</table>

Note the differences in the `GEOID` column between the two tables of data. When a county or geographic entity changes its name, the Census Bureau assigns it a new `GEOID`, meaning that analysts need to take care when dealing with those changes. A full listing of geography changes [is available on the Census website for each year](https://www.census.gov/programs-surveys/acs/technical-documentation/table-and-geography-changes.2019.html).

In addition to changes in geographic identifiers, variable IDs can change over time as well. For example, the ACS Data Profile is commonly used for pre-computed normalized ACS estimates. Let's say that we are interested in analyzing the percentage of residents age 25 and up with a 4-year college degree for counties in Colorado from the 2019 1-year ACS. We'd first look up the appropriate variable ID with `load_variables(2019, "acs1/profile")` then use `get_acs()`:


```r
co_college19 <- get_acs(
  geography = "county",
  variables = "DP02_0068P",
  state = "CO",
  survey = "acs1",
  year = 2019
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:co-college-19-show)ACS Data Profile data in 2019</caption>
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
   <td style="text-align:left;"> 08001 </td>
   <td style="text-align:left;"> Adams County, Colorado </td>
   <td style="text-align:left;"> DP02_0068P </td>
   <td style="text-align:right;"> 25.4 </td>
   <td style="text-align:right;"> 1.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 08005 </td>
   <td style="text-align:left;"> Arapahoe County, Colorado </td>
   <td style="text-align:left;"> DP02_0068P </td>
   <td style="text-align:right;"> 43.8 </td>
   <td style="text-align:right;"> 1.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 08013 </td>
   <td style="text-align:left;"> Boulder County, Colorado </td>
   <td style="text-align:left;"> DP02_0068P </td>
   <td style="text-align:right;"> 64.8 </td>
   <td style="text-align:right;"> 1.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 08014 </td>
   <td style="text-align:left;"> Broomfield County, Colorado </td>
   <td style="text-align:left;"> DP02_0068P </td>
   <td style="text-align:right;"> 56.9 </td>
   <td style="text-align:right;"> 3.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 08031 </td>
   <td style="text-align:left;"> Denver County, Colorado </td>
   <td style="text-align:left;"> DP02_0068P </td>
   <td style="text-align:right;"> 53.1 </td>
   <td style="text-align:right;"> 1.1 </td>
  </tr>
</tbody>
</table>

We get back data for counties of population 65,000 and greater as these are the geographies available in the 1-year ACS. The data make sense: Boulder County, home to the University of Colorado, has a very high percentage of its population with a 4-year degree or higher. However, when we run the exact same query for the 2018 1-year ACS:


```r
co_college18 <- get_acs(
  geography = "county",
  variables = "DP02_0068P",
  state = "CO",
  survey = "acs1",
  year = 2018
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:co-college-18-show)ACS Data Profile data in 2018</caption>
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
   <td style="text-align:left;"> 08001 </td>
   <td style="text-align:left;"> Adams County, Colorado </td>
   <td style="text-align:left;"> DP02_0068P </td>
   <td style="text-align:right;"> 375798 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 08005 </td>
   <td style="text-align:left;"> Arapahoe County, Colorado </td>
   <td style="text-align:left;"> DP02_0068P </td>
   <td style="text-align:right;"> 497198 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 08013 </td>
   <td style="text-align:left;"> Boulder County, Colorado </td>
   <td style="text-align:left;"> DP02_0068P </td>
   <td style="text-align:right;"> 263938 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 08014 </td>
   <td style="text-align:left;"> Broomfield County, Colorado </td>
   <td style="text-align:left;"> DP02_0068P </td>
   <td style="text-align:right;"> 53400 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 08031 </td>
   <td style="text-align:left;"> Denver County, Colorado </td>
   <td style="text-align:left;"> DP02_0068P </td>
   <td style="text-align:right;"> 575870 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
</tbody>
</table>

The values are completely different, and clearly not percentages! This is because variable IDs for the Data Profile **are unique to each year** and in turn should not be used for time-series analysis. The returned results above represent the civilian population age 18 and up, and have nothing to do with educational attainment.

### Preparing time-series ACS estimates

A safer way to perform time-series analysis of the ACS, then, is to use the Detailed Tables. While this option lacks the convenience of the pre-computed estimates in the Data Profile, it ensures that variable IDs will remain consistent across years allowing for consistent and correct analysis. That said, there still are some potential pitfalls to account for when using the Detailed Tables. The Census Bureau will add and remove variables from survey to survey depending on data needs and data availability. For example, questions are sometimes added and removed from the ACS survey meaning that you won't always be able to get every data point for every year and geography combination. In turn, it is still important to check on data availability using `load_variables()` for the years you plan to analyze before carrying out your time-series analysis.

Let's re-engineer the analysis above on educational attainment in Colorado counties, which below will be computed for a time series from 2010 to 2019. Information on "bachelor's degree or higher" is split by sex and across different tiers of educational attainment in the detailed tables, found in ACS table 15002. Given that we only need a few variables (representing estimates of populations age 25+ who have finished a 4-year degree or graduate degrees, by sex), we'll request those variables directly rather than the entire B15002 table.


```r
college_vars <- c("B15002_015",
                  "B15002_016",
                  "B15002_017",
                  "B15002_018",
                  "B15002_032",
                  "B15002_033",
                  "B15002_034",
                  "B15002_035")
```

We'll now use these variables to request data on college degree holders from the ACS for counties in Colorado for each of the 1-year ACS surveys from 2010 to 2019. In most cases, this process should be streamlined with *iteration*. Thus far, we are familiar with using the `year` argument in `get_acs()` to request data for a specific year. Writing out ten different calls to `get_acs()`, however - one for each year - would be tedious and would require a fair amount of repetitive code! Iteration helps us avoid repetitive coding as it allows us to carry out the same process over a sequence of values. Programmers familiar with iteration will likely know of "loop" operators like `for` and `while`, which are available in base R and most other programming languages in some variety. Base R also includes the `*apply()` family of functions (e.g. `lapply()`, `mapply()`, `sapply()`), which iterates over a sequence of values and applies a given function to each value.

The tidyverse approach to iteration is found in the **purrr** package. **purrr** includes a variety of functions that are designed to integrate well in workflows that require iteration and use other tidyverse tools. The `map_*()` family of functions iterate over values and try to return a desired result; `map()` returns a list, `map_int()` returns an integer vector, and `map_chr()` returns a character vector, for example. With tidycensus, the `map_dfr()` function is particularly useful. `map_dfr()` iterates over an input and applies it to a function or process defined by the user, then row-binds the result into a single data frame. The example below illustrates how this works for the years 2010 through 2019.


```r
years <- 2010:2019
names(years) <- years

college_by_year <- map_dfr(years, ~{
  get_acs(
    geography = "county",
    variables = college_vars,
    state = "CO",
    summary_var = "B15002_001",
    survey = "acs1",
    year = .x
  )
}, .id = "year")
```

For users newer to R, iteration and purrr syntax can feel complex, so it is worth stepping through how the above code sample works.

-   First, a numeric vector of years is defined with the syntax `2010:2019`. This will create a vector of years at 1-year intervals. These values are set as the names of the vector as well, as `map_dfr()` has additional functionality for working with named objects.

-   `map_dfr()` then takes three arguments above.

    -   The first argument is the object that `map_dfr()` will iterate over, which in this case is our `years` vector. This means that the process we set up will be run once for each element of `years`.
    -   The second argument is a formula we specify with the tilde (`~`) operator and curly braces (`{...}`). The code inside the curly braces will be run once for each element of `years`. The local variable `.x`, used inside the formula, takes on each value of `years` sequentially. In turn, we are running the equivalent of `get_acs()` with `year = 2010`, `year = 2011`, and so forth. Once `get_acs()` is run for each year, the result is combined into a single output data frame.
    -   The `.id` argument, which is optional but used here, creates a new column in the output data frame that contains values equivalent to the names of the input object, which in this case is `years`. By setting `.id = "year"`, we tell `map_dfr()` to name the new column that will contain these values `year`.

Let's review the result:


```r
college_by_year %>% 
  arrange(NAME, variable, year)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:college-by-year-show)Educational attainment over time</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> year </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> estimate </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> moe </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> summary_est </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> summary_moe </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:left;"> 08001 </td>
   <td style="text-align:left;"> Adams County, Colorado </td>
   <td style="text-align:left;"> B15002_015 </td>
   <td style="text-align:right;"> 20501 </td>
   <td style="text-align:right;"> 1983 </td>
   <td style="text-align:right;"> 275849 </td>
   <td style="text-align:right;"> 790 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:left;"> 08001 </td>
   <td style="text-align:left;"> Adams County, Colorado </td>
   <td style="text-align:left;"> B15002_015 </td>
   <td style="text-align:right;"> 21233 </td>
   <td style="text-align:right;"> 2124 </td>
   <td style="text-align:right;"> 281231 </td>
   <td style="text-align:right;"> 865 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:left;"> 08001 </td>
   <td style="text-align:left;"> Adams County, Colorado </td>
   <td style="text-align:left;"> B15002_015 </td>
   <td style="text-align:right;"> 19238 </td>
   <td style="text-align:right;"> 2020 </td>
   <td style="text-align:right;"> 287924 </td>
   <td style="text-align:right;"> 693 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:left;"> 08001 </td>
   <td style="text-align:left;"> Adams County, Colorado </td>
   <td style="text-align:left;"> B15002_015 </td>
   <td style="text-align:right;"> 23818 </td>
   <td style="text-align:right;"> 2445 </td>
   <td style="text-align:right;"> 295122 </td>
   <td style="text-align:right;"> 673 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:left;"> 08001 </td>
   <td style="text-align:left;"> Adams County, Colorado </td>
   <td style="text-align:left;"> B15002_015 </td>
   <td style="text-align:right;"> 20255 </td>
   <td style="text-align:right;"> 1928 </td>
   <td style="text-align:right;"> 304394 </td>
   <td style="text-align:right;"> 541 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:left;"> 08001 </td>
   <td style="text-align:left;"> Adams County, Colorado </td>
   <td style="text-align:left;"> B15002_015 </td>
   <td style="text-align:right;"> 22962 </td>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:right;"> 312281 </td>
   <td style="text-align:right;"> 705 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:left;"> 08001 </td>
   <td style="text-align:left;"> Adams County, Colorado </td>
   <td style="text-align:left;"> B15002_015 </td>
   <td style="text-align:right;"> 25744 </td>
   <td style="text-align:right;"> 2149 </td>
   <td style="text-align:right;"> 318077 </td>
   <td style="text-align:right;"> 525 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:left;"> 08001 </td>
   <td style="text-align:left;"> Adams County, Colorado </td>
   <td style="text-align:left;"> B15002_015 </td>
   <td style="text-align:right;"> 26159 </td>
   <td style="text-align:right;"> 2320 </td>
   <td style="text-align:right;"> 324185 </td>
   <td style="text-align:right;"> 562 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:left;"> 08001 </td>
   <td style="text-align:left;"> Adams County, Colorado </td>
   <td style="text-align:left;"> B15002_015 </td>
   <td style="text-align:right;"> 28113 </td>
   <td style="text-align:right;"> 2078 </td>
   <td style="text-align:right;"> 331247 </td>
   <td style="text-align:right;"> 955 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2019 </td>
   <td style="text-align:left;"> 08001 </td>
   <td style="text-align:left;"> Adams County, Colorado </td>
   <td style="text-align:left;"> B15002_015 </td>
   <td style="text-align:right;"> 27552 </td>
   <td style="text-align:right;"> 2070 </td>
   <td style="text-align:right;"> 336931 </td>
   <td style="text-align:right;"> 705 </td>
  </tr>
</tbody>
</table>

The result is a long-form dataset that contains a time series of each requested ACS variable for each county in Colorado that is available in the 1-year ACS. The code below outlines a `group_by() %>% summarize()` workflow for calculating the percentage of the population age 25 and up with a 4-year college degree, then uses the `pivot_wider()` function from the tidyr package to spread the years across the columns for tabular data display.


```r
percent_college_by_year <- college_by_year %>%
  group_by(NAME, year) %>%
  summarize(numerator = sum(estimate),
            denominator = first(summary_est)) %>%
  mutate(pct_college = 100 * (numerator / denominator)) %>%
  pivot_wider(id_cols = NAME,
              names_from = year,
              values_from = pct_college)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:pct-college-by-year-show)Percent college by year</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> NAME </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> 2010 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> 2011 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> 2012 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> 2013 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> 2014 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> 2015 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> 2016 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> 2017 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> 2018 </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> 2019 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Adams County, Colorado </td>
   <td style="text-align:right;"> 20.57394 </td>
   <td style="text-align:right;"> 20.51801 </td>
   <td style="text-align:right;"> 20.64538 </td>
   <td style="text-align:right;"> 23.09384 </td>
   <td style="text-align:right;"> 22.16929 </td>
   <td style="text-align:right;"> 22.79742 </td>
   <td style="text-align:right;"> 22.95293 </td>
   <td style="text-align:right;"> 22.87552 </td>
   <td style="text-align:right;"> 25.74152 </td>
   <td style="text-align:right;"> 25.39956 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Arapahoe County, Colorado </td>
   <td style="text-align:right;"> 37.03001 </td>
   <td style="text-align:right;"> 38.24506 </td>
   <td style="text-align:right;"> 39.28435 </td>
   <td style="text-align:right;"> 39.42478 </td>
   <td style="text-align:right;"> 40.94194 </td>
   <td style="text-align:right;"> 41.03578 </td>
   <td style="text-align:right;"> 41.48359 </td>
   <td style="text-align:right;"> 43.69387 </td>
   <td style="text-align:right;"> 42.71285 </td>
   <td style="text-align:right;"> 43.78332 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Boulder County, Colorado </td>
   <td style="text-align:right;"> 57.50285 </td>
   <td style="text-align:right;"> 59.05601 </td>
   <td style="text-align:right;"> 57.88284 </td>
   <td style="text-align:right;"> 58.53214 </td>
   <td style="text-align:right;"> 58.04066 </td>
   <td style="text-align:right;"> 60.57147 </td>
   <td style="text-align:right;"> 60.63005 </td>
   <td style="text-align:right;"> 63.18150 </td>
   <td style="text-align:right;"> 62.51394 </td>
   <td style="text-align:right;"> 64.80486 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Broomfield County, Colorado </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 56.07776 </td>
   <td style="text-align:right;"> 51.94338 </td>
   <td style="text-align:right;"> 55.13359 </td>
   <td style="text-align:right;"> 56.27740 </td>
   <td style="text-align:right;"> 56.87181 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Denver County, Colorado </td>
   <td style="text-align:right;"> 40.87971 </td>
   <td style="text-align:right;"> 42.97122 </td>
   <td style="text-align:right;"> 44.65358 </td>
   <td style="text-align:right;"> 44.35340 </td>
   <td style="text-align:right;"> 44.25600 </td>
   <td style="text-align:right;"> 47.10820 </td>
   <td style="text-align:right;"> 47.39683 </td>
   <td style="text-align:right;"> 49.32692 </td>
   <td style="text-align:right;"> 51.34580 </td>
   <td style="text-align:right;"> 53.10088 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Douglas County, Colorado </td>
   <td style="text-align:right;"> 54.96800 </td>
   <td style="text-align:right;"> 53.27936 </td>
   <td style="text-align:right;"> 55.09223 </td>
   <td style="text-align:right;"> 57.66999 </td>
   <td style="text-align:right;"> 56.48866 </td>
   <td style="text-align:right;"> 56.06928 </td>
   <td style="text-align:right;"> 59.42687 </td>
   <td style="text-align:right;"> 58.53342 </td>
   <td style="text-align:right;"> 58.37539 </td>
   <td style="text-align:right;"> 58.13747 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> El Paso County, Colorado </td>
   <td style="text-align:right;"> 34.11467 </td>
   <td style="text-align:right;"> 35.69184 </td>
   <td style="text-align:right;"> 34.91315 </td>
   <td style="text-align:right;"> 35.47612 </td>
   <td style="text-align:right;"> 36.49302 </td>
   <td style="text-align:right;"> 36.43089 </td>
   <td style="text-align:right;"> 38.67864 </td>
   <td style="text-align:right;"> 39.19931 </td>
   <td style="text-align:right;"> 38.83872 </td>
   <td style="text-align:right;"> 39.04942 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Jefferson County, Colorado </td>
   <td style="text-align:right;"> 40.83113 </td>
   <td style="text-align:right;"> 39.54961 </td>
   <td style="text-align:right;"> 41.43825 </td>
   <td style="text-align:right;"> 41.04234 </td>
   <td style="text-align:right;"> 41.99768 </td>
   <td style="text-align:right;"> 43.20923 </td>
   <td style="text-align:right;"> 43.51953 </td>
   <td style="text-align:right;"> 45.57140 </td>
   <td style="text-align:right;"> 45.83786 </td>
   <td style="text-align:right;"> 47.61074 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Larimer County, Colorado </td>
   <td style="text-align:right;"> 45.80197 </td>
   <td style="text-align:right;"> 42.83543 </td>
   <td style="text-align:right;"> 44.71423 </td>
   <td style="text-align:right;"> 43.33800 </td>
   <td style="text-align:right;"> 42.67180 </td>
   <td style="text-align:right;"> 46.16705 </td>
   <td style="text-align:right;"> 46.78871 </td>
   <td style="text-align:right;"> 47.90465 </td>
   <td style="text-align:right;"> 47.62330 </td>
   <td style="text-align:right;"> 49.01654 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Mesa County, Colorado </td>
   <td style="text-align:right;"> 24.99285 </td>
   <td style="text-align:right;"> 25.82724 </td>
   <td style="text-align:right;"> 23.01511 </td>
   <td style="text-align:right;"> 27.63325 </td>
   <td style="text-align:right;"> 25.14875 </td>
   <td style="text-align:right;"> 30.27630 </td>
   <td style="text-align:right;"> 25.02980 </td>
   <td style="text-align:right;"> 25.82455 </td>
   <td style="text-align:right;"> 29.95739 </td>
   <td style="text-align:right;"> 29.78537 </td>
  </tr>
</tbody>
</table>

This particular format is suitable for data display or writing to an Excel spreadsheet for colleagues who are not R-based. Methods for visualization of time-series estimates from the ACS will be covered in Section \@ref(visualizing-acs-estimates-over-time).

## Handling margins of error in the American Community Survey with tidycensus

A topic of critical importance when working with data from the American Community Survey is the *margin of error*. As opposed to the decennial US Census, which is based on a complete enumeration of the US population, the ACS is based on a sample with estimates characterized by margins of error. By default, MOEs are returned at a 90 percent confidence level. This can be translated roughtly as "we are 90 percent sure that the true value falls within a range defined by the estimate plus or minus the margin of error."

As discussed in Chapter 2, **tidycensus** takes an opinionated approach to margins of error. When applicable, **tidycensus** will always return the margin of error associated with an estimate, and does not have an option available to return estimates only. For "tidy" or long-form data, these margins of error will be found in the `moe` column; for wide-form data, margins of error will be found in columns with an `M` suffix.

The confidence level of the MOE can be controlled with the `moe_level` argument in `get_acs()`. The default `moe_level` is 90, which is what the Census Bureau returns by default. tidycensus can also return MOEs at a confidence level of `95` or `99` which uses Census Bureau-recommended formulas to adjust the MOE. For example, we might look at data on median household income by county in Rhode Island using the default `moe_level` of 90:


```r
get_acs(
  geography = "county",
  state = "Rhode Island",
  variables = "B19013_001"
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:default-moe-show)Default MOE at 90 percent confidence level</caption>
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
   <td style="text-align:left;"> 44001 </td>
   <td style="text-align:left;"> Bristol County, Rhode Island </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 83092 </td>
   <td style="text-align:right;"> 4339 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 44003 </td>
   <td style="text-align:left;"> Kent County, Rhode Island </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 73521 </td>
   <td style="text-align:right;"> 1703 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 44005 </td>
   <td style="text-align:left;"> Newport County, Rhode Island </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 79454 </td>
   <td style="text-align:right;"> 2611 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 44007 </td>
   <td style="text-align:left;"> Providence County, Rhode Island </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 58974 </td>
   <td style="text-align:right;"> 1051 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 44009 </td>
   <td style="text-align:left;"> Washington County, Rhode Island </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 85531 </td>
   <td style="text-align:right;"> 2042 </td>
  </tr>
</tbody>
</table>

A stricter margin of error will increase the size of the MOE relative to its estimate.


```r
get_acs(
  geography = "county",
  state = "Rhode Island",
  variables = "B19013_001",
  moe_level = 99
)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:moe-level-99-show)MOE at 99 percent confidence level</caption>
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
   <td style="text-align:left;"> 44001 </td>
   <td style="text-align:left;"> Bristol County, Rhode Island </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 83092 </td>
   <td style="text-align:right;"> 6752.486 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 44003 </td>
   <td style="text-align:left;"> Kent County, Rhode Island </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 73521 </td>
   <td style="text-align:right;"> 2650.261 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 44005 </td>
   <td style="text-align:left;"> Newport County, Rhode Island </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 79454 </td>
   <td style="text-align:right;"> 4063.319 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 44007 </td>
   <td style="text-align:left;"> Providence County, Rhode Island </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 58974 </td>
   <td style="text-align:right;"> 1635.599 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 44009 </td>
   <td style="text-align:left;"> Washington County, Rhode Island </td>
   <td style="text-align:left;"> B19013_001 </td>
   <td style="text-align:right;"> 85531 </td>
   <td style="text-align:right;"> 3177.824 </td>
  </tr>
</tbody>
</table>

### Calculating derived margins of error in tidycensus

For small geographies or small populations, margins of error can get quite large, in some cases exceeding their corresponding estimates. In the example below, we can examine data on age groups by sex for the population age 65 and older for Census tracts in Salt Lake County, Utah.


```r
vars <- paste0("B01001_0", c(20:25, 44:49))

salt_lake <- get_acs(
  geography = "tract",
  variables = vars,
  state = "Utah",
  county = "Salt Lake",
  year = 2019
)
```

Let's focus on a specific Census tract in Salt Lake County using `filter()`:


```r
example_tract <- salt_lake %>%
  filter(GEOID == "49035100100")

example_tract %>% 
  select(-NAME)
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:salt-lake-example-show)Example Census tract in Salt Lake City</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> variable </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> estimate </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> moe </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 49035100100 </td>
   <td style="text-align:left;"> B01001_020 </td>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 13 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100100 </td>
   <td style="text-align:left;"> B01001_021 </td>
   <td style="text-align:right;"> 36 </td>
   <td style="text-align:right;"> 23 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100100 </td>
   <td style="text-align:left;"> B01001_022 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100100 </td>
   <td style="text-align:left;"> B01001_023 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100100 </td>
   <td style="text-align:left;"> B01001_024 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100100 </td>
   <td style="text-align:left;"> B01001_025 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 23 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100100 </td>
   <td style="text-align:left;"> B01001_044 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100100 </td>
   <td style="text-align:left;"> B01001_045 </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 13 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100100 </td>
   <td style="text-align:left;"> B01001_046 </td>
   <td style="text-align:right;"> 27 </td>
   <td style="text-align:right;"> 20 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100100 </td>
   <td style="text-align:left;"> B01001_047 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 12 </td>
  </tr>
</tbody>
</table>

In many cases, the margins of error exceed their corresponding estimates. For example, the ACS data suggest that in Census tract 49035100100, for the male population age 85 and up (variable ID `B01001_0025`), there are anywhere between 0 and 45 people in that Census tract. This can make ACS data for small geographies problematic for planning and analysis purposes.

A potential solution to large margins of error for small estimates in the ACS is to aggregate data upwards until a satisfactory margin of error to estimate ratio is reached. [The US Census Bureau publishes formulas for appropriately calculating margins of error around such derived estimates](https://www2.census.gov/programs-surveys/acs/tech_docs/statistical_testing/2018_Instructions_for_Stat_Testing_ACS.pdf?), which are included in tidycensus with the following functions:

-   `moe_sum()`: calculates a margin of error for a derived sum;
-   `moe_product()`: calculates a margin of error for a derived product;
-   `moe_ratio()`: calculates a margin of error for a derived ratio;
-   `moe_prop()`: calculates a margin of error for a derived proportion.

In their most basic form, these functions can be used with constants. For example, let's say we had an ACS estimate of 25 with a margin of error of 5 around that estimate. The appropriate denominator for this estimate is 100 with a margin of error of 3. To determine the margin of error around the derived proportion of 0.25, we can use `moe_prop()`:


```r
moe_prop(25, 100, 5, 3)
```

```
## [1] 0.0494343
```

Our margin of error around the derived estimate of 0.25 is approximately 0.049.

### Calculating group-wise margins of error

These margin of error functions in **tidycensus** can in turn be integrated into tidyverse-centric analytic pipelines to handle large margins of error around estimates. Given that the smaller age bands in the Salt Lake City dataset are characterized by too much uncertainty for our analysis, we decide in this scenario to aggregate our data upwards to represent populations aged 65 and older by sex.

In the code below, we use the `case_when()` function to create a new column, `sex`, that represents a mapping of the variables we pulled from the ACS to their sex categories. We then employ a familiar `group_by() %>% summarize()` method to aggregate our data by Census tract and sex. Notably, the call to `summarize()` includes a call to tidycensus's `moe_sum()` function, which will generate a new column that represents the margin of error around the derived sum.


```r
salt_lake_grouped <- salt_lake %>%
  mutate(sex = case_when(
    str_sub(variable, start = -2) < "26" ~ "Male",
    TRUE ~ "Female"
  )) %>%
  group_by(GEOID, sex) %>%
  summarize(sum_est = sum(estimate), 
            sum_moe = moe_sum(moe, estimate))
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:summarize-moe-show)Grouped margins of error</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> GEOID </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> sex </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> sum_est </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> sum_moe </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 49035100100 </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:right;"> 30.90307 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100100 </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:right;"> 83 </td>
   <td style="text-align:right;"> 39.15354 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100200 </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:right;"> 167 </td>
   <td style="text-align:right;"> 57.49783 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100200 </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:right;"> 153 </td>
   <td style="text-align:right;"> 50.85273 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100306 </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:right;"> 273 </td>
   <td style="text-align:right;"> 108.80257 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100306 </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:right;"> 225 </td>
   <td style="text-align:right;"> 90.27181 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100307 </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:right;"> 188 </td>
   <td style="text-align:right;"> 70.24956 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100307 </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:right;"> 117 </td>
   <td style="text-align:right;"> 64.54456 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100308 </td>
   <td style="text-align:left;"> Female </td>
   <td style="text-align:right;"> 164 </td>
   <td style="text-align:right;"> 98.66610 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 49035100308 </td>
   <td style="text-align:left;"> Male </td>
   <td style="text-align:right;"> 129 </td>
   <td style="text-align:right;"> 77.89095 </td>
  </tr>
</tbody>
</table>

The margins of error relative to their estimates are now much more reasonable than in the disaggregated data.

That said, [the Census Bureau issues a note of caution](https://www2.census.gov/programs-surveys/acs/tech_docs/statistical_testing/2019_Instructions_for_Stat_Testing_ACS.pdf?) [@acs_moe]:

> All [derived MOE methods] are approximations and users should be cautious in using them. This is because these methods do not consider the correlation or covariance between the basic estimates. They may be overestimates or underestimates of the derived estimate's standard error depending on whether the two basic estimates are highly correlated in either the positive or negative direction. As a result, the approximated standard error may not match direct calculations of standard errors or calculations obtained through other methods.

This means that your "best bet" is to first search the ACS tables to see if your data are found in aggregated form elsewhere before doing the aggregation and MOE estimation yourself. In many cases, you'll find aggregated information in the ACS combined tables, Data Profile, or Subject Tables that will include pre-computed margins of error for you.

## Exercises

-   The ACS Data Profile includes a number of pre-computed percentages which can reduce your data wrangling time. The variable in the 2015-2019 ACS for "percent of the population age 25 and up with a bachelor's degree" is `DP02_0068P`. For a state of your choosing, use this variable to determine:

    -   The county with the highest percentage in the state;

    -   The county with the lowest percentage in the state;

    -   The median value for counties in your chosen state.
