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

e.g. "Sheet1!A2:B3" will now access Sheet1 if it exists (or throw an error if it does not). Sheets defined in ranges overrule sheets defined using `sheets`

## Merged cells now work correctly (Issue #2)

The value for the merged cell is placed in the top-left cell. All other cells that were part of the merge are `NA`. 

**Note:** This isn't actually necessarily true. The OO spec allows cells covered by merges to contain values,, although these are not displayed (by Excel anyway). This contents is in fact parsed in the same way as a normal cell however. This poses a small problem as the output in this case is not the same as the user might expect, however it faithfully records the information held in the sheet. It's not possible to add data to cells this way using spreadsheet software (that I know of) so this is unlikely to be an issue.

The problem mentioned by DataStategist in Issue #2 still persists, in that moving the data to the top-left of the merged cell does not always line up visually with the intention of the author, however without a lot of second-guessing it is not possible to know which cell is the most appropriate for the contents to lie in. 


## Speed (Issue #37)

Parsing is now done in C++ which should significantly improve speed. Performance is similar for small sheets, and significantly faster for larger workbooks. The memory footprint for larger sheets is also reduced, which goes some way towards solving Issue #71, although the whole of `contents.xml` still needs to be loaded into memory at once, and so there is still a limit. The file referenced in the issue now takes ~10GB of ram, and loads in ~2 mins on my machine, which is still slow, but an improvement. 

Speed is also improved as the package will now only parse the requested range of a sheet if requested, which significantly speeds up gathering a small amount of data from a large sheet

## Why no objects and classes? That's what readxl does!

I think they make things hard to read (and I am bad at them). We could create a worksheet object and use internal methods to read the data, 
but it would still need to be instantiated every time we read the sheet. 