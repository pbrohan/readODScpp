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

## read_fods

Now reads flat ods files using `read_fods`. This checks to make sure that it's a correct single-document ODS file, and uses a common .read_ods function internally to read either flat or packaged ODS files. Doesn't have a function to distinguish (a la `read_excel`), as the sensible name for this would be `read_ods`. Could check inside function maybe, but this would require either the file extensions to be correct, or some other marker to be identified. 

Also added related `list_fods_sheets` and `get_num_sheets_in_fods`

## Why no objects and classes? That's what readxl does!

I think they make things hard to read (and I am bad at them). We could create a worksheet object and use internal methods to read the data, 
but it would still need to be instantiated every time we read the sheet. 

## How do read_ods_ (and read_flat_ods_) work now?
 
`.standardise_limits()` converts the range request into limits in the form `c(min_row, max_row, min_col, max_col)`. If `max_row` or `max_col` are -1, this reads to the edge of the spreadsheet in the y or x direction respectively.

The list of sheets in the file is then parsed to check if the sheet name is valid.
(This is not optimal, as this parses the sheet twice when it could be done during the main read. It's not actually that slow though, so I've left it for now).

The xml contents file is then read into memory using `rapidxml`.

**`read_ods_()`** or **`read_flat_ods_()`** then attempts to parse the sheet, running **`find_rows()`** to build an array of pointers to the nodes containing the cells of of the spreadsheet (although only those requested in the range). The maximal width of this array is then the width of the resulting array. 

We then loop through the array to build a vector of strings, beginning with the width and length of the output as strings. We then parse the cells into this vector in order, padding any rows which are not of sufficient length. This string is passed back to R.

The remainder is similar to the previous version, this list of strings is turned into a matrix of appropriate dimensions, which becomes a dataframe, is given headers and has the column types assigned by `readr`.