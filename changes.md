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


## Why no objects and classes? That's what readxl does!

I think they make things hard to read. We could create a worksheet object and use internal methods to read the data, 
but it would still need to be instantiated every time we read the sheet. 