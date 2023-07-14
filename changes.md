# Changes

## list_ods_sheets

Now has additional parameter `include_external_data`. When set to `FALSE` (default) hides linked data sheets.

**Why?** This is the default behaviour for spreadsheet software, and, I would argue, what users are expecting.
Linked external data is not generally accessible in this manner, and would usually be expected to be accessed
through the front-facing sheet into which it was imported. 

This is also the default behaviour for packages reading `.xls` and `.xlsx` files, and external data is presented
for ods files largely because the file format considers it in the same manner as other sheets.

**Why not?** Many other packages (previous versions of readODS, tidyODS, pandas) do not exhibit this behaviour
by default, and so this would represent a change of functionality.

## Changed behaviour when accesing small amounts of data

- Now reads single columns from sheets when requested (previously gave `Error in irow:nrow(x) : argument of length 0)
- When a sheet returns a single row or column (or a single element), and passed `true` for row names or column names, now raises a warning and returns the data without names (previously would name the columns, add a row above/or below the column, and also return the data, e.g. a sheet with just `A` in A1 would return: 

``` bash
     A
1   NA
2    A
```

Now raises `Cannot make column/row names if this would cause the dataframe to be empty.` and returns

``` bash
    V1
1   A
```

## Range now accepts sheets as part of text

e.g. "Sheet1!A2:B3"

## Why no objects and classes? That's what readxl does!

I think they make things hard to read. We could create a worksheet object and use internal methods to read the data, 
but it would still need to be instantiated every time we read the sheet. 