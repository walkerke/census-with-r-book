# Wrangling Census data with tidyverse tools



One of the most popular frameworks for data analysis in R is the **tidyverse**, a suite of packages designed for integrated data wrangling, visualization, and modeling. The "tidy" or long-form data returned by default in tidycensus is designed to work well with tidyverse analytic workflows. This chapter provides an overview of how to use tidyverse tools to gain additional insights about US Census data retrieved with tidycensus. It concludes with discussion about margins of error (MOEs) in the American Community Survey and how to wrangle and interpret MOEs appropriately.

## The tidyverse

[The tidyverse](https://www.tidyverse.org/) is a collection of R packages that are designed to work together in common data wrangling, analysis, and visualization projects. These R packages are maintained by RStudio, many of which are among the most popular R packages worldwide. Some of the key packages you'll use in the tidyverse include:

-   readr, which contains tools for importing and exporting datasets;

-   dplyr, a powerful framework for data wrangling tasks;

-   tidyr, a package for reshaping data;

-   purrr, a comprehensive framework for functional programming and iteration;

-   ggplot2, a data visualization package based on the Grammar of Graphics

The core data structure used in the tidyverse is the *tibble*, which is an R data frame with some small enhancements to improve the user experience. tidycensus returns tibbles by default.

A full treatment of the tidyverse and its functionality is beyond the scope of this book; however, the examples in this chapter will introduce you to several key tidyverse features using US Census Bureau data. For a more general and broader treatment of the tidyverse, I recommend the [*R for Data Science*](https://r4ds.had.co.nz/index.html)text (cite here)

## Exploring Census data with tidyverse tools

Census data queries using tidycensus, combined with core tidyverse functions, are excellent ways to explore downloaded Census data. Chapter 2 covered how to download data from various Census datasets using tidycensus and return the data in a desired format. A common next step in an analytic process will involve data exploration, which is handled by a wide range of tools in the tidyverse.

To get started, the tidycensus and tidyverse packages are loaded. "tidyverse" is not specifically a package itself, but rather loads several core packages within the tidyverse. The package load message gives you more information:


```r
library(tidycensus)
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
```

```
## ✓ ggplot2 3.3.3     ✓ purrr   0.3.4
## ✓ tibble  3.1.2     ✓ dplyr   1.0.6
## ✓ tidyr   1.1.3     ✓ stringr 1.4.0
## ✓ readr   1.4.0     ✓ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

Eight tidyverse packages are loaded: ggplot2, tibble, purrr, dplyr, readr, and tidyr are included along with stringr for string manipulation and forcats for working with factors. These tools collectively can be used for many core Census data analysis tasks.

### Sorting and filtering data

For a first example, let's request data on median age from the 2015-2019 ACS with `get_acs()` for all counties in the United States. This requires specifying `geography = "county"` and leaving state set to `NULL`, the default.


```r
median_age <- get_acs(
  geography = "county",
  variables = "B01002_001",
  year = 2019
)

median_age
```

```
## # A tibble: 3,220 x 5
##    GEOID NAME                     variable   estimate   moe
##    <chr> <chr>                    <chr>         <dbl> <dbl>
##  1 01001 Autauga County, Alabama  B01002_001     38.2   0.6
##  2 01003 Baldwin County, Alabama  B01002_001     43     0.3
##  3 01005 Barbour County, Alabama  B01002_001     40.4   0.5
##  4 01007 Bibb County, Alabama     B01002_001     40.9   1.3
##  5 01009 Blount County, Alabama   B01002_001     40.7   0.3
##  6 01011 Bullock County, Alabama  B01002_001     40.2   2.3
##  7 01013 Butler County, Alabama   B01002_001     40.8   0.7
##  8 01015 Calhoun County, Alabama  B01002_001     39.6   0.3
##  9 01017 Chambers County, Alabama B01002_001     42     0.7
## 10 01019 Cherokee County, Alabama B01002_001     46.5   0.5
## # … with 3,210 more rows
```

The default method for printing data used by the tibble package shows the first 10 rows of the dataset, which in this case prints counties in Alabama. A first exploratory data analysis question might involve understanding which counties are the *youngest* and *oldest* in the United States as measured by median age. This task can be accomplished with the `arrange()` function found in the dplyr package. `arrange()` sorts a dataset by values in one or more columns and returns the sorted result. To view the dataset in ascending order of a given column, supply the data object and a column name to the `arrange()` function.


```r
arrange(median_age, estimate)
```

```
## # A tibble: 3,220 x 5
##    GEOID NAME                          variable   estimate   moe
##    <chr> <chr>                         <chr>         <dbl> <dbl>
##  1 51678 Lexington city, Virginia      B01002_001     22.3   0.7
##  2 51750 Radford city, Virginia        B01002_001     23.4   0.5
##  3 16065 Madison County, Idaho         B01002_001     23.5   0.2
##  4 46121 Todd County, South Dakota     B01002_001     23.8   0.4
##  5 02158 Kusilvak Census Area, Alaska  B01002_001     24.1   0.2
##  6 13053 Chattahoochee County, Georgia B01002_001     24.5   0.5
##  7 53075 Whitman County, Washington    B01002_001     24.7   0.3
##  8 49049 Utah County, Utah             B01002_001     24.8   0.1
##  9 46027 Clay County, South Dakota     B01002_001     24.9   0.4
## 10 51830 Williamsburg city, Virginia   B01002_001     24.9   0.7
## # … with 3,210 more rows
```

Per the 2015-2019 ACS, the two youngest "counties" in the United States are independent cities in Virginia, which are treated as county-equivalents. Both Lexington and Radford are college towns; Lexington is home to both Washington & Lee University and the Virginia Military Institute, and Radford houses Radford University. The youngest *county* then by median age is Madison County Idaho.

To retrieve the *oldest* counties in the United States by median age, an analyst can use the `desc()` function available in dplyr to sort the `estimate` column in descending order.


```r
arrange(median_age, desc(estimate))
```

```
## # A tibble: 3,220 x 5
##    GEOID NAME                            variable   estimate   moe
##    <chr> <chr>                           <chr>         <dbl> <dbl>
##  1 12119 Sumter County, Florida          B01002_001     67.4   0.2
##  2 51091 Highland County, Virginia       B01002_001     60.9   3.5
##  3 08027 Custer County, Colorado         B01002_001     59.7   2.6
##  4 12015 Charlotte County, Florida       B01002_001     59.1   0.2
##  5 41069 Wheeler County, Oregon          B01002_001     59     3.3
##  6 51133 Northumberland County, Virginia B01002_001     58.9   0.7
##  7 26131 Ontonagon County, Michigan      B01002_001     58.6   0.4
##  8 35021 Harding County, New Mexico      B01002_001     58.5   5.5
##  9 53031 Jefferson County, Washington    B01002_001     58.3   0.7
## 10 26001 Alcona County, Michigan         B01002_001     58.2   0.3
## # … with 3,210 more rows
```

The oldest county in the United States by almost 7 years over the second-oldest is Sumter County, Florida. Sumter County is home to The Villages, a Census-designated place that includes a large age-restricted community [also called The Villages](https://www.thevillages.com/).

The tidyverse includes several tools for parsing datasets that allow for exploration beyond sorting and browsing data. The `filter()` function in dplyr queries a dataset for rows where a given condition evaluates to `TRUE`, and retains those rows only. For analysts who are familiar with databases and SQL, this is equivalent to a `WHERE` clause. This helps analysts subset their data for specific areas by their characteristics, and answer questions like "how many counties in the US have a median age of 50 or older?"


```r
filter(median_age, estimate >= 50)
```

```
## # A tibble: 216 x 5
##    GEOID NAME                        variable   estimate   moe
##    <chr> <chr>                       <chr>         <dbl> <dbl>
##  1 04007 Gila County, Arizona        B01002_001     50.2   0.2
##  2 04012 La Paz County, Arizona      B01002_001     56.5   0.5
##  3 04015 Mohave County, Arizona      B01002_001     51.6   0.3
##  4 04025 Yavapai County, Arizona     B01002_001     53.4   0.1
##  5 05005 Baxter County, Arkansas     B01002_001     52.2   0.3
##  6 05089 Marion County, Arkansas     B01002_001     52.2   0.5
##  7 05097 Montgomery County, Arkansas B01002_001     50.4   0.8
##  8 05137 Stone County, Arkansas      B01002_001     50.1   0.7
##  9 06003 Alpine County, California   B01002_001     52.2   8.8
## 10 06005 Amador County, California   B01002_001     50.5   0.4
## # … with 206 more rows
```

Functions like `arrange()` and `filter()` operate on row values and organize data by row. Other tidyverse functions, like tidyr's `separate()`, operate on columns. The `NAME` column, returned by default by most tidycensus functions, contains a basic description of the location that can be more intuitive than the `GEOID`. For the 2015-2019 ACS, `NAME` is formatted as "X County, Y", where X is the county name and Y is the state name. `separate()` can split this column into two columns where one retains the county name and the other retains the state; this can be useful for analysts who need to complete a comparative analysis by state.


```r
separate(
  median_age,
  NAME,
  into = c("county", "state"),
  sep = ", "
)
```

```
## # A tibble: 3,220 x 6
##    GEOID county          state   variable   estimate   moe
##    <chr> <chr>           <chr>   <chr>         <dbl> <dbl>
##  1 01001 Autauga County  Alabama B01002_001     38.2   0.6
##  2 01003 Baldwin County  Alabama B01002_001     43     0.3
##  3 01005 Barbour County  Alabama B01002_001     40.4   0.5
##  4 01007 Bibb County     Alabama B01002_001     40.9   1.3
##  5 01009 Blount County   Alabama B01002_001     40.7   0.3
##  6 01011 Bullock County  Alabama B01002_001     40.2   2.3
##  7 01013 Butler County   Alabama B01002_001     40.8   0.7
##  8 01015 Calhoun County  Alabama B01002_001     39.6   0.3
##  9 01017 Chambers County Alabama B01002_001     42     0.7
## 10 01019 Cherokee County Alabama B01002_001     46.5   0.5
## # … with 3,210 more rows
```

\`\`\`{block2, note-text, type='rmdtip'}

You may have noticed above that existing variable names are *unquoted* when referenced in tidyverse functions. Many tidyverse functions use *non-standard evaluation* to refer to column names, which means that column names can be used as arguments directly without quotation marks. Non-standard evaluation makes interactive programming faster, especially for beginners; however, it can introduce some complications when writing your own functions or R packages. A full treatment of non-standard evaluation is beyond the scope of this book; [Hadley Wickham's *Advanced R*](https://adv-r.hadley.nz/metaprogramming.html) is the best resource on the topic if you'd like to learn more.

\`\`\`

### Using summary variables and calculating new columns

Data in Census and ACS tables, as in the example above, are frequently comprised of variables that individually constitute sub-categories such as the numbers of households in different household income bands. One limitation of the approach above, however, is that the data - and the resulting analysis - return estimated counts, which are difficult to compare across geographies. For example, Maricopa County in Arizona is the state's most populous county with 4.3 million residents; the second-largest county, Pima, only has just over 1 million residents and six of the state's 15 counties have fewer than 100,000 residents. In turn, comparing Maricopa's estimates with those of smaller counties in the state would often be inappropriate.

A solution to this issue might involve **normalizing** the estimated count data by dividing it by the overall population from which the sub-group is derived. Appropriate denominators for ACS tables are frequently found in the tables themselves as variables. In ACS table B19001, which covers the number of households by income bands, the variable `B19001_001` represents the total number of households in a given enumeration unit, which we removed from our analysis earlier. Given that this variable is an appropriate denominator for the other variables in the table, it merits its own column to facilitate the calculation of proportions or percentages.

In tidycensus, this can be accomplished by supplying a variable ID to the `summary_var` parameter in both the `get_acs()` and `get_decennial()` functions. Doing so will create two new columns for the decennial Census datasets - `summary_var` and `summary_value`, representing the summary variable ID and the summary variable's value - and three new columns for the ACS datasets, `summary_var`, `summary_est`, and `summary_moe`, which includes the ACS estimate and margin of error for the summary variable.

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

az_race
```

```
## # A tibble: 90 x 7
##    GEOID NAME                    variable estimate   moe summary_est summary_moe
##    <chr> <chr>                   <chr>       <dbl> <dbl>       <dbl>       <dbl>
##  1 04001 Apache County, Arizona  White       13022     4       71511          NA
##  2 04001 Apache County, Arizona  Black         373   138       71511          NA
##  3 04001 Apache County, Arizona  Native      52285   234       71511          NA
##  4 04001 Apache County, Arizona  Asian         246    78       71511          NA
##  5 04001 Apache County, Arizona  HIPI           16    16       71511          NA
##  6 04001 Apache County, Arizona  Hispanic     4531    NA       71511          NA
##  7 04003 Cochise County, Arizona White       69216   235      125867          NA
##  8 04003 Cochise County, Arizona Black        4620   247      125867          NA
##  9 04003 Cochise County, Arizona Native       1142   191      125867          NA
## 10 04003 Cochise County, Arizona Asian        2431   162      125867          NA
## # … with 80 more rows
```

By using dplyr's `mutate()` function, we calculate a new column, `percent`, representing the percentage of each Census tract's population that corresponds to each racial/ethnic group in 2015-2019. The `select()` function, also in dplyr, retains only those columns that we need to view.


```r
az_race_percent <- az_race %>%
  mutate(percent = 100 * (estimate / summary_est)) %>%
  select(NAME, variable, percent)

az_race_percent
```

```
## # A tibble: 90 x 3
##    NAME                    variable percent
##    <chr>                   <chr>      <dbl>
##  1 Apache County, Arizona  White    18.2   
##  2 Apache County, Arizona  Black     0.522 
##  3 Apache County, Arizona  Native   73.1   
##  4 Apache County, Arizona  Asian     0.344 
##  5 Apache County, Arizona  HIPI      0.0224
##  6 Apache County, Arizona  Hispanic  6.34  
##  7 Cochise County, Arizona White    55.0   
##  8 Cochise County, Arizona Black     3.67  
##  9 Cochise County, Arizona Native    0.907 
## 10 Cochise County, Arizona Asian     1.93  
## # … with 80 more rows
```

The above example introduces some additional syntax common to tidyverse data analyses. The `%>%` operator from the magrittr R package is a *pipe* operator that allows for analysts to develop *analytic pipelines*, which are deeply embedded in tidyverse-centric data analytic workflows. The pipe operator passes the result of a given line of code as the first argument of the code on the next line. In turn, analysts can develop data analysis pipelines of related operations that fit together in a coherent way.

tidyverse developers recommend that the pipe operator be read as "then". The above code can in turn be interpreted as "Create a new data object `az_race_percent` by using the existing data object `az_race` THEN creating a new `percent` column THEN selecting the `NAME`, `variable`, and `percent` columns."

Since R version 4.1, the base installation of R also includes a pipe operator, `|>`. It works much the same way as the magrittr pipe `%>%`, though `%>%` has some small additional features that make it work well within tidyverse analysis pipelines. In turn, `%>%` will be used in the examples throughout this book.

## Group-wise Census data analysis

The split-apply-combine model of data analysis, as discussed in @wickham2011, is a powerful framework for analyzing demographic data. In general terms, an analyst will apply this framework as follows:

-   The analyst identifies salient groups in a dataset between which they want to make comparisons. The dataset is then **split** into multiple pieces, one for each group.

-   A function is then **applied** to each group in turn. This might be a simple summary function, such as taking the maximum or calculating the mean, or a custom function defined by the analyst.

-   Finally, the results of the function applied to each group are **combined** back into a single dataset, allowing the analyst to compare the results by group.

Given the hierarchical nature of US Census Bureau data, "groups" across which analysts can make comparisons are found in just about every analytic tasks.  In many cases, the split-apply-combine model of data analysis will be useful to analysts as they make sense of patterns and trends found in Census data.  

In the tidyverse, split-apply-combine is implemented with the `group_by()` function in the dplyr package.  `group_by()` does the work for the analyst of splitting a dataset into groups, allowing subsequent functions used by the analyst in an analytic pipeline to be applied to each group then combined back into a single dataset.  The examples that follow illustrate some common group-wise analyses.  

### Making group-wise comparisons

The `az_race_percent` dataset created above is an example of a dataset suitable for group-wise data analysis.  It includes two columns that could be used as group definitions: `NAME`, representing the county, and `variable`, representing the racial or ethnic group.  Split-apply-combine could be used for either group definition to make comparisons for data in Arizona across these categories.  

In a first example, we can deploy group-wise data analysis to identify the largest racial or ethnic group in each county in Arizona.  This involves setting up a data analysis pipeline with the magrittr pipe and calculating a _grouped filter_ where the `filter()` operation will be applied specific to each group.  In this example, the filter condition will be specified as `percent == max(percent)`.  We can read the analytic pipeline then as "Create a new dataset, `largest_group`, by using the `az_race_dataset` THEN grouping the dataset by the `NAME` column THEN filtering for rows that are equal to the maximum value of `percent` for each group."


```r
largest_group <- az_race_percent %>%
  group_by(NAME) %>%
  filter(percent == max(percent))

largest_group
```

```
## # A tibble: 15 x 3
## # Groups:   NAME [15]
##    NAME                       variable percent
##    <chr>                      <chr>      <dbl>
##  1 Apache County, Arizona     Native      73.1
##  2 Cochise County, Arizona    White       55.0
##  3 Coconino County, Arizona   White       54.1
##  4 Gila County, Arizona       White       62.3
##  5 Graham County, Arizona     White       50.9
##  6 Greenlee County, Arizona   Hispanic    46.8
##  7 La Paz County, Arizona     White       57.4
##  8 Maricopa County, Arizona   White       55.2
##  9 Mohave County, Arizona     White       77.3
## 10 Navajo County, Arizona     Native      43.5
## 11 Pima County, Arizona       White       51.7
## 12 Pinal County, Arizona      White       56.8
## 13 Santa Cruz County, Arizona Hispanic    83.5
## 14 Yavapai County, Arizona    White       80.5
## 15 Yuma County, Arizona       Hispanic    63.8
```

The result of the grouped filter allows us to review the most common racial or ethnic group in each Arizona County along with how their percentages vary.  For example, in two Arizona counties (Greenlee and Navajo), none of the racial or ethnic groups form a majority of the population.  

`group_by()` is commonly paired with the `summarize()` function in data analysis pipelines.  `summarize()` generates a new, compressed dataset that by default returns a column for the grouping variable(s) and columns representing the results of one or more functions applied to those groups.  In the example below, the `median()` function is used to identify the median percentage for each of the racial & ethnic groups in the dataset across counties in Arizona.  In turn, `variable` is passed to `group_by()` as the grouping variable.  


```r
az_race_percent %>%
  group_by(variable) %>%
  summarize(median_pct = median(percent))
```

```
## # A tibble: 6 x 2
##   variable median_pct
##   <chr>         <dbl>
## 1 Asian         0.924
## 2 Black         1.12 
## 3 HIPI          0.121
## 4 Hispanic     30.2  
## 5 Native        3.58 
## 6 White        54.1
```
The result of this operation tells us the median county percentage of each racial and ethnic group for the state of Arizona.  A broader analysis might involve the calculation of these percentages hierarchically, finding the median county percentage of given attributes across states, for example.  

### Tabulating new groups

In the examples above, suitable groups in the `NAME` and `variable` columns were already found in the data retrieved with `get_acs()`.  Commonly, analysts will also need to calculate new custom groups to address specific analytic questions.  For example, variables in ACS table B19001 represent groups of households whose household incomes fall into a variety of categories: less than \$10,000/year, between \$10,000/year and \$19,999/year, and so forth. These categories may be more granular than needed by an analyst. As such, an analyst might take the following steps: 1) recode the ACS variables into wider income bands; 2) group the data by the wider income bands; 3) calculate grouped sums to generate new estimates.

Consider the following example, using household income data for Minnesota counties from the 2012-2016 ACS:


```r
mn_hh_income <- get_acs(
  geography = "county",
  table = "B19001",
  state = "MN",
  year = 2016
)

mn_hh_income
```

```
## # A tibble: 1,479 x 5
##    GEOID NAME                     variable   estimate   moe
##    <chr> <chr>                    <chr>         <dbl> <dbl>
##  1 27001 Aitkin County, Minnesota B19001_001     7640   262
##  2 27001 Aitkin County, Minnesota B19001_002      562    77
##  3 27001 Aitkin County, Minnesota B19001_003      544    72
##  4 27001 Aitkin County, Minnesota B19001_004      472    69
##  5 27001 Aitkin County, Minnesota B19001_005      508    68
##  6 27001 Aitkin County, Minnesota B19001_006      522    92
##  7 27001 Aitkin County, Minnesota B19001_007      447    61
##  8 27001 Aitkin County, Minnesota B19001_008      390    49
##  9 27001 Aitkin County, Minnesota B19001_009      426    64
## 10 27001 Aitkin County, Minnesota B19001_010      415    65
## # … with 1,469 more rows
```

Our data include household income categories for each county in the rows. However, let's say we only need three income categories for purposes of analysis: below \$35,000/year, between \$35,000/year and \$75,000/year, and \$75,000/year and up.

We first need to do some transformation of our data to recode the variables appropriately. First, we will remove variable `B19001_001`, which represents the total number of households for each county. Second, we use the `case_when()` function from the **dplyr** package to identify groups of variables that correspond to our desired groupings.  Given that the variables are ordered in the ACS table in relationship to the household income values, the less than operator can be used to identify groups.  

The syntax of `case_when()` can appear complex to beginners, so it is worth stepping through how the function works.  Inside the `mutate()` function, which is used to create a new variable named `incgroup`, `case_when()` steps through a series of logical conditions that are evaluated in order similar to a series of if/else statements.  The first condition is evaluated, telling the function to assign the value of `below35k` to all rows with a `variable` value that comes before `"B19001_008"` - which in this case will be `B19001_002` (income less than $10,000) through `B19001_007` (income between $30,000 and $34,999).  The second condition is then evaluated _for all those rows not accounted for by the first condition_.  This means that `case_when()` knows not to assign `"bw35kand75k"` to the income group of $10,000 and below even though its variable comes before `B19001_013`.  The final condition in `case_when()` can be set to `TRUE` which in this scenario translates as "all other values."  


```r
mn_hh_income_recode <- mn_hh_income %>%
  filter(variable != "B19001_001") %>%
  mutate(incgroup = case_when(
    variable < "B19001_008" ~ "below35k", 
    variable < "B19001_013" ~ "bw35kand75k", 
    TRUE ~ "above75k"
  )) 

mn_hh_income_recode
```

```
## # A tibble: 1,392 x 6
##    GEOID NAME                     variable   estimate   moe incgroup   
##    <chr> <chr>                    <chr>         <dbl> <dbl> <chr>      
##  1 27001 Aitkin County, Minnesota B19001_002      562    77 below35k   
##  2 27001 Aitkin County, Minnesota B19001_003      544    72 below35k   
##  3 27001 Aitkin County, Minnesota B19001_004      472    69 below35k   
##  4 27001 Aitkin County, Minnesota B19001_005      508    68 below35k   
##  5 27001 Aitkin County, Minnesota B19001_006      522    92 below35k   
##  6 27001 Aitkin County, Minnesota B19001_007      447    61 below35k   
##  7 27001 Aitkin County, Minnesota B19001_008      390    49 bw35kand75k
##  8 27001 Aitkin County, Minnesota B19001_009      426    64 bw35kand75k
##  9 27001 Aitkin County, Minnesota B19001_010      415    65 bw35kand75k
## 10 27001 Aitkin County, Minnesota B19001_011      706    81 bw35kand75k
## # … with 1,382 more rows
```

Our result illustrates how the different variable IDs are mapped to the new, recoded categories that we specified in `case_when()`.  The `group_by() %>% summarize()` workflow can now be applied to the recoded categories by county to tabulate the data into a smaller number of groups.  


```r
mn_group_sums <- mn_hh_income_recode %>%
  group_by(GEOID, incgroup) %>%
  summarize(estimate = sum(estimate))

mn_group_sums
```

```
## # A tibble: 261 x 3
## # Groups:   GEOID [87]
##    GEOID incgroup    estimate
##    <chr> <chr>          <dbl>
##  1 27001 above75k        1706
##  2 27001 below35k        3055
##  3 27001 bw35kand75k     2879
##  4 27003 above75k       61403
##  5 27003 below35k       24546
##  6 27003 bw35kand75k    39311
##  7 27005 above75k        4390
##  8 27005 below35k        4528
##  9 27005 bw35kand75k     4577
## 10 27007 above75k        4491
## # … with 251 more rows
```

Our data now reflect the new estimates by group by county.

## Comparing ACS estimates over time

A common task when working with Census data is to examine demographic change over time.  Data from the Census API - and consequently tidycensus - only go back to the 2000 Decennial Census. For historical analysts who want to go even further back, decennial Census data are available since 1790 from the [National Historical Geographic Information System](https://www.nhgis.org/), or NHGIS, which will be covered in detail in Chapter 11.

### A warning: inconsistent variable IDs in the ACS Data Profile

One advantage to working with ACS data is that it includes a rich yearly time series going back to 2005 for the 1-year ACS and 2005-2009 for the 5-year ACS.  This allows analysts to examine recent demographic shifts in a relatively consistent way.  However, it is important to take care when performing time series analysis.  For example, the ACS Data Profile is commonly used for pre-computed normalized ACS estimates.  Let's say that we are interested in analyzing the percentage of residents age 25 and up with a 4-year college degree for counties in Colorado from the 2019 1-year ACS.  We'd first look up the appropriate variable ID with `load_variables(2019, "acs1/profile")` then use `get_acs()`:


```r
co_college19 <- get_acs(
  geography = "county",
  variables = "DP02_0068P",
  state = "CO",
  survey = "acs1",
  year = 2019
)

co_college19
```

```
## # A tibble: 12 x 5
##    GEOID NAME                        variable   estimate   moe
##    <chr> <chr>                       <chr>         <dbl> <dbl>
##  1 08001 Adams County, Colorado      DP02_0068P     25.4   1.3
##  2 08005 Arapahoe County, Colorado   DP02_0068P     43.8   1.3
##  3 08013 Boulder County, Colorado    DP02_0068P     64.8   1.8
##  4 08014 Broomfield County, Colorado DP02_0068P     56.9   3.3
##  5 08031 Denver County, Colorado     DP02_0068P     53.1   1.1
##  6 08035 Douglas County, Colorado    DP02_0068P     58.1   1.8
##  7 08041 El Paso County, Colorado    DP02_0068P     39     1.3
##  8 08059 Jefferson County, Colorado  DP02_0068P     47.6   1.2
##  9 08069 Larimer County, Colorado    DP02_0068P     49     1.8
## 10 08077 Mesa County, Colorado       DP02_0068P     29.8   2.6
## 11 08101 Pueblo County, Colorado     DP02_0068P     23.4   2  
## 12 08123 Weld County, Colorado       DP02_0068P     29.9   1.6
```
We get back data for counties of population 65,000 and greater as these are the geographies available in the 1-year ACS. The data make sense: Boulder County, home to the University of Colorado, has a very high percentage of its population with a 4-year degree or higher. However, when we run the exact same query for the 2018 1-year ACS:


```r
co_college18 <- get_acs(
  geography = "county",
  variables = "DP02_0068P",
  state = "CO",
  survey = "acs1",
  year = 2018
)

co_college18
```

```
## # A tibble: 12 x 5
##    GEOID NAME                        variable   estimate   moe
##    <chr> <chr>                       <chr>         <dbl> <dbl>
##  1 08001 Adams County, Colorado      DP02_0068P   375798    NA
##  2 08005 Arapahoe County, Colorado   DP02_0068P   497198    NA
##  3 08013 Boulder County, Colorado    DP02_0068P   263938    NA
##  4 08014 Broomfield County, Colorado DP02_0068P    53400    NA
##  5 08031 Denver County, Colorado     DP02_0068P   575870    NA
##  6 08035 Douglas County, Colorado    DP02_0068P   252922    NA
##  7 08041 El Paso County, Colorado    DP02_0068P   513528    NA
##  8 08059 Jefferson County, Colorado  DP02_0068P   465615    NA
##  9 08069 Larimer County, Colorado    DP02_0068P   281086    NA
## 10 08077 Mesa County, Colorado       DP02_0068P   119498    NA
## 11 08101 Pueblo County, Colorado     DP02_0068P   129899    NA
## 12 08123 Weld County, Colorado       DP02_0068P   231613    NA
```
The values are completely different, and clearly not percentages!  This is because variable IDs for the Data Profile __are unique to each year__ and in turn should not be used for time-series analysis.  The returned results above represent the civilian population age 18 and up, and have nothing to do with educational attainment.  

### Preparing time-series ACS estimates

A safer way to perform time-series analysis of the ACS, then, is to use the Detailed Tables.  While this option lacks the convenience of the pre-computed estimates in the Data Profile, it ensures that variable IDs will remain consistent across years allowing for consistent and correct analysis.  That said, there still are some potential pitfalls to account for when using the Detailed Tables.  The Census Bureau will add and remove variables from survey to survey depending on data needs and data availability.  For example, questions are sometimes added and removed from the ACS survey meaning that you won't always be able to get every data point for every year and geography combination.  In turn, it is still important to check on data availability using `load_variables()` for the years you plan to analyze before carrying out your time-series analysis.  

Let's re-engineer the analysis above on educational attainment in Colorado counties, which below will be computed for a time series from 2010 to 2019.  Information on "bachelor's degree or higher" is split by sex and across different tiers of educational attainment in the detailed tables, found in ACS table 15002.  Given that we only need a few variables (representing estimates of populations age 25+ who have finished a 4-year degree or graduate degrees, by sex), we'll request those variables directly rather than the entire B15002 table.  


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

We'll now use these variables to request data on college degree holders from the ACS for counties in Colorado for each of the 1-year ACS surveys from 2010 to 2019.  In most cases, this process should be streamlined with _iteration_.  Thus far, we are familiar with using the `year` argument in `get_acs()` to request data for a specific year.  Writing out ten different calls to `get_acs()`, however - one for each year - would be tedious and would require a fair amount of repetitive code!  Iteration helps us avoid repetitive coding as it allows us to carry out the same process over a sequence of values.  Programmers familiar with iteration will likely know of "loop" operators like `for` and `while`, which are available in base R and most other programming languages in some variety.  Base R also includes the `*apply()` family of functions (e.g. `lapply()`, `mapply()`, `sapply()`), which iterates over a sequence of values and applies a given function to each value.  

The tidyverse approach to iteration is found in the purrr package.  purrr includes a variety of functions that are designed to integrate well in workflows that require iteration and use other tidyverse tools.  The `map_()` family of functions iterate over values and try to return a desired result; `map()` returns a list, `map_int()` returns an integer vector, and `map_chr()` returns a character vector, for example.  With tidycensus, the `map_dfr()` function is particularly useful.  `map_dfr()` iterates over an input and applies it to a function or process defined by the user, then row-binds the result into a single data frame.  The example below illustrates how this works for the years 2010 through 2019.   


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

* First, a numeric vector of years is defined with the syntax `2010:2019`. This will create a vector of years at 1-year intervals.  These values are set as the names of the vector as well, as `map_dfr()` has additional functionality for working with named objects.  
* `map_dfr()` then takes three arguments above.  
  - The first argument is the object that `map_dfr()` will iterate over, which in this case is our `years` vector.  This means that the process we set up will be run once for each element of `years`.  
  - The second argument is a formula we specify with the tilde (`~`) operator and curly braces (`{...}`).  The code inside the curly braces will be run once for each element of `years`.  The local variable `.x`, used inside the formula, takes on each value of `years` sequentially.  In turn, we are running the equivalent of `get_acs()` with `year = 2010`, `year = 2011`, and so forth. Once `get_acs()` is run for each year, the result is combined into a single output data frame.
  - The `.id` argument, which is optional but used here, creates a new column in the output data frame that contains values equivalent to the names of the input object, which in this case is `years`.  By setting `.id = "year"`, we tell `map_dfr()` to name the new column that will contain these values `year`.  

Let's review the result:
  

```r
college_by_year %>% arrange(NAME, variable, year) %>% glimpse()
```

```
## Rows: 920
## Columns: 8
## $ year        <chr> "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2…
## $ GEOID       <chr> "08001", "08001", "08001", "08001", "08001", "08001", "080…
## $ NAME        <chr> "Adams County, Colorado", "Adams County, Colorado", "Adams…
## $ variable    <chr> "B15002_015", "B15002_015", "B15002_015", "B15002_015", "B…
## $ estimate    <dbl> 20501, 21233, 19238, 23818, 20255, 22962, 25744, 26159, 28…
## $ moe         <dbl> 1983, 2124, 2020, 2445, 1928, 2018, 2149, 2320, 2078, 2070…
## $ summary_est <dbl> 275849, 281231, 287924, 295122, 304394, 312281, 318077, 32…
## $ summary_moe <dbl> 790, 865, 693, 673, 541, 705, 525, 562, 955, 705, 790, 865…
```

The result is a long-form dataset that contains a time series of each requested ACS variable for each county in Colorado that is available in the 1-year ACS.  The code below outlines a `group_by() %>% summarize()` workflow for calculating the percentage of the population age 25 and up with a 4-year college degree, then uses the `pivot_wider()` function from the tidyr package to spread the years across the columns for tabular data display.  


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

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> NAME </th>
   <th style="text-align:right;"> 2010 </th>
   <th style="text-align:right;"> 2011 </th>
   <th style="text-align:right;"> 2012 </th>
   <th style="text-align:right;"> 2013 </th>
   <th style="text-align:right;"> 2014 </th>
   <th style="text-align:right;"> 2015 </th>
   <th style="text-align:right;"> 2016 </th>
   <th style="text-align:right;"> 2017 </th>
   <th style="text-align:right;"> 2018 </th>
   <th style="text-align:right;"> 2019 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Adams County, Colorado </td>
   <td style="text-align:right;"> 20.6 </td>
   <td style="text-align:right;"> 20.5 </td>
   <td style="text-align:right;"> 20.6 </td>
   <td style="text-align:right;"> 23.1 </td>
   <td style="text-align:right;"> 22.2 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 23.0 </td>
   <td style="text-align:right;"> 22.9 </td>
   <td style="text-align:right;"> 25.7 </td>
   <td style="text-align:right;"> 25.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Arapahoe County, Colorado </td>
   <td style="text-align:right;"> 37.0 </td>
   <td style="text-align:right;"> 38.2 </td>
   <td style="text-align:right;"> 39.3 </td>
   <td style="text-align:right;"> 39.4 </td>
   <td style="text-align:right;"> 40.9 </td>
   <td style="text-align:right;"> 41.0 </td>
   <td style="text-align:right;"> 41.5 </td>
   <td style="text-align:right;"> 43.7 </td>
   <td style="text-align:right;"> 42.7 </td>
   <td style="text-align:right;"> 43.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Boulder County, Colorado </td>
   <td style="text-align:right;"> 57.5 </td>
   <td style="text-align:right;"> 59.1 </td>
   <td style="text-align:right;"> 57.9 </td>
   <td style="text-align:right;"> 58.5 </td>
   <td style="text-align:right;"> 58.0 </td>
   <td style="text-align:right;"> 60.6 </td>
   <td style="text-align:right;"> 60.6 </td>
   <td style="text-align:right;"> 63.2 </td>
   <td style="text-align:right;"> 62.5 </td>
   <td style="text-align:right;"> 64.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Broomfield County, Colorado </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 56.1 </td>
   <td style="text-align:right;"> 51.9 </td>
   <td style="text-align:right;"> 55.1 </td>
   <td style="text-align:right;"> 56.3 </td>
   <td style="text-align:right;"> 56.9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Denver County, Colorado </td>
   <td style="text-align:right;"> 40.9 </td>
   <td style="text-align:right;"> 43.0 </td>
   <td style="text-align:right;"> 44.7 </td>
   <td style="text-align:right;"> 44.4 </td>
   <td style="text-align:right;"> 44.3 </td>
   <td style="text-align:right;"> 47.1 </td>
   <td style="text-align:right;"> 47.4 </td>
   <td style="text-align:right;"> 49.3 </td>
   <td style="text-align:right;"> 51.3 </td>
   <td style="text-align:right;"> 53.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Douglas County, Colorado </td>
   <td style="text-align:right;"> 55.0 </td>
   <td style="text-align:right;"> 53.3 </td>
   <td style="text-align:right;"> 55.1 </td>
   <td style="text-align:right;"> 57.7 </td>
   <td style="text-align:right;"> 56.5 </td>
   <td style="text-align:right;"> 56.1 </td>
   <td style="text-align:right;"> 59.4 </td>
   <td style="text-align:right;"> 58.5 </td>
   <td style="text-align:right;"> 58.4 </td>
   <td style="text-align:right;"> 58.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> El Paso County, Colorado </td>
   <td style="text-align:right;"> 34.1 </td>
   <td style="text-align:right;"> 35.7 </td>
   <td style="text-align:right;"> 34.9 </td>
   <td style="text-align:right;"> 35.5 </td>
   <td style="text-align:right;"> 36.5 </td>
   <td style="text-align:right;"> 36.4 </td>
   <td style="text-align:right;"> 38.7 </td>
   <td style="text-align:right;"> 39.2 </td>
   <td style="text-align:right;"> 38.8 </td>
   <td style="text-align:right;"> 39.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Jefferson County, Colorado </td>
   <td style="text-align:right;"> 40.8 </td>
   <td style="text-align:right;"> 39.5 </td>
   <td style="text-align:right;"> 41.4 </td>
   <td style="text-align:right;"> 41.0 </td>
   <td style="text-align:right;"> 42.0 </td>
   <td style="text-align:right;"> 43.2 </td>
   <td style="text-align:right;"> 43.5 </td>
   <td style="text-align:right;"> 45.6 </td>
   <td style="text-align:right;"> 45.8 </td>
   <td style="text-align:right;"> 47.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Larimer County, Colorado </td>
   <td style="text-align:right;"> 45.8 </td>
   <td style="text-align:right;"> 42.8 </td>
   <td style="text-align:right;"> 44.7 </td>
   <td style="text-align:right;"> 43.3 </td>
   <td style="text-align:right;"> 42.7 </td>
   <td style="text-align:right;"> 46.2 </td>
   <td style="text-align:right;"> 46.8 </td>
   <td style="text-align:right;"> 47.9 </td>
   <td style="text-align:right;"> 47.6 </td>
   <td style="text-align:right;"> 49.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Mesa County, Colorado </td>
   <td style="text-align:right;"> 25.0 </td>
   <td style="text-align:right;"> 25.8 </td>
   <td style="text-align:right;"> 23.0 </td>
   <td style="text-align:right;"> 27.6 </td>
   <td style="text-align:right;"> 25.1 </td>
   <td style="text-align:right;"> 30.3 </td>
   <td style="text-align:right;"> 25.0 </td>
   <td style="text-align:right;"> 25.8 </td>
   <td style="text-align:right;"> 30.0 </td>
   <td style="text-align:right;"> 29.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Pueblo County, Colorado </td>
   <td style="text-align:right;"> 19.5 </td>
   <td style="text-align:right;"> 23.5 </td>
   <td style="text-align:right;"> 19.9 </td>
   <td style="text-align:right;"> 21.3 </td>
   <td style="text-align:right;"> 23.6 </td>
   <td style="text-align:right;"> 21.6 </td>
   <td style="text-align:right;"> 21.2 </td>
   <td style="text-align:right;"> 22.2 </td>
   <td style="text-align:right;"> 21.8 </td>
   <td style="text-align:right;"> 23.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Weld County, Colorado </td>
   <td style="text-align:right;"> 25.1 </td>
   <td style="text-align:right;"> 24.7 </td>
   <td style="text-align:right;"> 26.3 </td>
   <td style="text-align:right;"> 27.4 </td>
   <td style="text-align:right;"> 25.7 </td>
   <td style="text-align:right;"> 25.9 </td>
   <td style="text-align:right;"> 27.2 </td>
   <td style="text-align:right;"> 27.5 </td>
   <td style="text-align:right;"> 27.4 </td>
   <td style="text-align:right;"> 29.9 </td>
  </tr>
</tbody>
</table>

This particular format is suitable for data display or writing to an Excel spreadsheet for colleagues who are not R-based.  In addition, Chapter 4 will address appropriate methods for visualization of this data.

## Handling margins of error in the American Community Survey with tidycensus

A topic of critical importance when working with data from the American Community Survey is the _margin of error_.  As opposed to the decennial US Census, which is based on a complete enumeration of the US population, the ACS is based on a sample with estimates characterized by margins of error.  By default, MOEs are returned at a 90 percent confidence level.  This can be translated roughtly as "we are 90 percent sure that the true value falls within a range defined by the estimate plus or minus the margin of error."  

As discussed in Chapter 2, tidycensus takes an opinionated approach to margins of error.  When applicable, tidycensus will always return the margin of error associated with an estimate, and does not have an option available to return estimates only.  For "tidy" or long-form data, these margins of error will be found in the `moe` column; for wide-form data, margins of error will be found in columns with an `M` suffix.  

The confidence level of the MOE can be controlled with the `moe_level` argument in `get_acs()`.  The default `moe_level` is 90, which is what the Census Bureau returns by default.  tidycensus can also return MOEs at a confidence level of `95` or `99` which uses Census Bureau-recommended formulas to adjust the MOE.  For example, we might look at data on median household income by county in Rhode Island using the default `moe_level` of 90: 


```r
library(tidycensus)

get_acs(
  geography = "county",
  state = "Rhode Island",
  variables = "B19013_001"
)
```

```
## # A tibble: 5 x 5
##   GEOID NAME                            variable   estimate   moe
##   <chr> <chr>                           <chr>         <dbl> <dbl>
## 1 44001 Bristol County, Rhode Island    B19013_001    83092  4339
## 2 44003 Kent County, Rhode Island       B19013_001    73521  1703
## 3 44005 Newport County, Rhode Island    B19013_001    79454  2611
## 4 44007 Providence County, Rhode Island B19013_001    58974  1051
## 5 44009 Washington County, Rhode Island B19013_001    85531  2042
```

A stricter margin of error will increase the size of the MOE relative to its estimate.


```r
get_acs(
  geography = "county",
  state = "Rhode Island",
  variables = "B19013_001",
  moe_level = 99
)
```

```
## # A tibble: 5 x 5
##   GEOID NAME                            variable   estimate   moe
##   <chr> <chr>                           <chr>         <dbl> <dbl>
## 1 44001 Bristol County, Rhode Island    B19013_001    83092 6752.
## 2 44003 Kent County, Rhode Island       B19013_001    73521 2650.
## 3 44005 Newport County, Rhode Island    B19013_001    79454 4063.
## 4 44007 Providence County, Rhode Island B19013_001    58974 1636.
## 5 44009 Washington County, Rhode Island B19013_001    85531 3178.
```

### Calculating derived margins of error in tidycensus

For small geographies or small populations, margins of error can get quite large, in some cases exceeding their corresponding estimates.  In the example below, we can examine data on age groups by sex for the population age 65 and older for Census tracts in Salt Lake County, Utah. 


```r
library(tidyverse)

vars <- paste0("B01001_0", c(20:25, 44:49))

salt_lake <- get_acs(
  geography = "tract",
  variables = vars,
  state = "Utah",
  county = "Salt Lake",
  year = 2019
)

example_tract <- salt_lake %>%
  filter(GEOID == "49035100100")

example_tract %>% select(-NAME)
```

```
## # A tibble: 12 x 4
##    GEOID       variable   estimate   moe
##    <chr>       <chr>         <dbl> <dbl>
##  1 49035100100 B01001_020       12    13
##  2 49035100100 B01001_021       36    23
##  3 49035100100 B01001_022        8    11
##  4 49035100100 B01001_023        5     8
##  5 49035100100 B01001_024        0    11
##  6 49035100100 B01001_025       22    23
##  7 49035100100 B01001_044        0    11
##  8 49035100100 B01001_045       11    13
##  9 49035100100 B01001_046       27    20
## 10 49035100100 B01001_047       10    12
## 11 49035100100 B01001_048        7    11
## 12 49035100100 B01001_049        0    11
```

In many cases, the margins of error exceed their corresponding estimates.  For example, the ACS data suggest that in Census tract 49035100100, for the male population age 85 and up (variable ID `B01001_0025`), there are anywhere between 0 and 45 people in that Census tract.  This can make ACS data for small geographies problematic for planning and analysis purposes.  

A potential solution to large margins of error for small estimates in the ACS is to aggregate data upwards until a satisfactory margin of error to estimate ratio is reached.  [The US Census Bureau publishes formulas for appropriately calculating margins of error around such derived estimates](https://www2.census.gov/programs-surveys/acs/tech_docs/statistical_testing/2018_Instructions_for_Stat_Testing_ACS.pdf?), which are included in tidycensus with the following functions: 

* `moe_sum()`: calculates a margin of error for a derived sum;
* `moe_product()`: calculates a margin of error for a derived product;
* `moe_ratio()`: calculates a margin of error for a derived ratio;
* `moe_prop()`: calculates a margin of error for a derived proportion.  

In their most basic form, these functions can be used with constants.  For example, let's say we had an ACS estimate of 25 with a margin of error of 5 around that estimate.  The appropriate denominator for this estimate is 100 with a margin of error of 3.  To determine the margin of error around the derived proportion of 0.25, we can use `moe_prop()`: 


```r
moe_prop(25, 100, 5, 3)
```

```
## [1] 0.0494343
```

Our margin of error around the derived estimate of 0.25 is approximately 0.049.  

### Calculating group-wise margins of error

These margin of error functions in tidycensus can in turn be integrated into tidyverse-centric analytic pipelines to handle large margins of error around estimates.  Given that the smaller age bands in the Salt Lake City dataset are characterized by too much uncertainty for our analysis, we decide in this scenario to aggregate our data upwards to represent populations aged 65 and older by sex.  

In the code below, we use the `if_else()` function to create a new column, `sex`, that represents a mapping of the variables we pulled from the ACS to their sex categories.  We then employ a familiar `group_by() %>% summarize()` method to aggregate our data by Census tract and sex.  Notably, the call to `summarize()` includes a call to tidycensus's `moe_sum()` function, which will generate a new column that represents the margin of error around the derived sum.  


```r
salt_lake_grouped <- salt_lake %>%
  mutate(sex = if_else(str_sub(variable, start = -2) < "26",
                       "Male", 
                       "Female")) %>%
  group_by(GEOID, sex) %>%
  summarize(sum_est = sum(estimate), 
            sum_moe = moe_sum(moe, estimate))


salt_lake_grouped
```

```
## # A tibble: 424 x 4
## # Groups:   GEOID [212]
##    GEOID       sex    sum_est sum_moe
##    <chr>       <chr>    <dbl>   <dbl>
##  1 49035100100 Female      55    30.9
##  2 49035100100 Male        83    39.2
##  3 49035100200 Female     167    57.5
##  4 49035100200 Male       153    50.9
##  5 49035100306 Female     273   109. 
##  6 49035100306 Male       225    90.3
##  7 49035100307 Female     188    70.2
##  8 49035100307 Male       117    64.5
##  9 49035100308 Female     164    98.7
## 10 49035100308 Male       129    77.9
## # … with 414 more rows
```
The margins of error relative to their estimates are now much more reasonable than in the disaggregated data.  

That said, the Census Bureau issues a note of caution: 

> All [derived MOE methods] are approximations and users should be cautious in using them.
This is because these methods do not consider the correlation or covariance between the basic
estimates. They may be overestimates or underestimates of the derived estimate’s standard error
depending on whether the two basic estimates are highly correlated in either the positive or
negative direction. As a result, the approximated standard error may not match direct
calculations of standard errors or calculations obtained through other methods.

This means that your "best bet" is to first search the ACS tables to see if your data are found in aggregated form elsewhere before doing the aggregation and MOE estimation yourself.  In many cases, you'll find aggregated information in the ACS combined tables, Data Profile, or Subject Tables that will include pre-computed margins of error for you.  

## Exercises

-   The ACS Data Profile includes a number of pre-computed percentages which can reduce your data wrangling time. The variable in the 2015-2019 ACS for "percent of the population age 25 and up with a bachelor's degree" is `DP02_0068P`. For a state of your choosing, use this variable to determine:

    -   The county with the highest percentage in the state;

    -   The county with the lowest percentage in the state;

    -   The median value for counties in your chosen state.
