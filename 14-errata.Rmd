# Errata {.unnumbered}

This page enumerates errors in the print version. The online version is kept up-to-date with corrections.

-   Chapter 3, p. 56: "roughtly" should be "roughly" (typo).
-   Chapter 6, p. 141: dot-density map lacks a figure caption and is not numbered as a figure.
-   Chapter 7, p. 183: the 2020 Census block shapefiles have renamed the `HU20` column to `HOUSING20` since publication.
-   Chapter 7, section 7.4: the hospitals object from DHS has changed since publication, and the code must be modified to run correctly.
    -   On p. 187, the correct hospital URL is now "[https://services1.arcgis.com/Hp6G80Pky0om7QvQ/arcgis/rest/services/Hospital/FeatureServer/0/query?outFields=\*&where=1%3D1&f=geojson"](https://services1.arcgis.com/Hp6G80Pky0om7QvQ/arcgis/rest/services/Hospital/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson%22).

    -   On p. 193, the name of Iowa Methodist Medical Center has changed. Use `ID == "0009850308"` in the `filter()` expression instead.
-   Chapter 8, p. 234: "indented" should be "intended" (typo).
-   Chapter 8, p. 244 and 246: beta symbol renders in the print version as a question mark; renders correctly in the HTML version
