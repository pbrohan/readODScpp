.change_df_with_col_row_header <- function(x, col_header, row_header){
    if((nrow(x) < 2 && col_header )|| (ncol(x) < 2 && row_header)){
        warning("Cannot make column/row names if this would cause the dataframe to be empty.")
        return(x)
    }
    irow <- ifelse(col_header, 2, 1)
    jcol <- ifelse(row_header, 2, 1)

    g <- x[irow:nrow(x), jcol:ncol(x), drop=FALSE] # maintain as dataframe for single column
    rownames(g) <- if(row_header) x[seq(irow, nrow(x)), 1] else NULL # don't want character row headers given by 1:nrow(g)
    colnames(g) <- if(col_header) x[1, seq(jcol, ncol(x))] else cellranger::num_to_letter(seq_len(ncol(g)))
    return(g)
}




## Based on readxl, although the implementation is different.
## If max row is -1, read to end of row. 
## Row and column-numbers are 1-based
.standardise_limits <- function(range, skip) {
    if(is.null(range)){
        skip <- check_nonnegative_integer(skip, "skip")
        limits <- c(
            min_row = skip,
            max_row = -1,
            min_col = 1,
            max_col = -1
        )
    } else {
        if(skip != 0){
            warning("Range and non-zero value for skip given. Defaulting to range.")
        }
        limits <- cellranger::as.cell_limits(range)
        limits <- c(
            min_row = limits[["ul"]][1],
            max_row = limits[["lr"]][1],
            min_col = limits[["ul"]][2],
            max_col = limits[["lr"]][2]
        )
    }
    return(limits)
}

.silent_type_convert <- function(x, verbose = TRUE, na = c("", "NA")) {
    if (verbose) {
        res <- readr::type_convert(df = x, na = na)
    } else {
        suppressMessages({
            res <- readr::type_convert(df = x, na = na)
        })
    }
    return(res)
}

.convert_strings_to_factors <- function(df) {
    i <- purrr::map_lgl(df, is.character)
    df[i] <- lapply(df[i], as.factor)
    return (df)
}

#' Read the data from an ODS file
#' 
#' 
#' 
read_ods_cpp <- function(path,
                        sheet = 1,
                        col_names = TRUE,
                        col_types = NULL,
                        na = "",
                        skip = 0,
                        formula_as_formula = FALSE,
                        range = NULL,
                        row_names = FALSE,
                        strings_as_factors = FALSE,
                        check_names = FALSE,
                        verbose = FALSE

){

    # Get cell range info
    limits <- .standardise_limits(range, skip)
    # Get sheet number.
    sheets <- ods_get_sheet_names(path, TRUE)
    sheet_name <- cellranger::as.cell_limits(range)[["sheet"]]
    if(!is.null(range) && !is.na(sheet_name)){
        if(sheet != 1){
            warning("Sheet suggested in range and using sheet argument. Defaulting to range", call. = FALSE)
        }
        if(sheet_name %in% sheets){
            sheet = match(sheet_name, sheets)
        } else {
            stop(paste0("No sheet found with name '", sheet_name, "'"), call. = FALSE)
        }
    } else {
        if (!is.numeric(sheet) && (sheet %in% sheets)){
            sheet = match(sheet, sheets)
        } else if (!is.numeric(sheet)) {
            stop(paste0("No sheet found with name '", sheet, "'", ),call. = FALSE)
        }
        if (sheet > length(sheets)){
            stop(paste0("File contains only ", length(sheets), " sheets. Sheet index out of range.", call. = FALSE))
        }
    }

    strings <- read_ods_(path,
        limits["min_row"],
        limits["max_row"],
        limits["min_col"],
        limits["max_col"],
        sheet,
        formula_as_formula)
    res <- strings[-1:-2] |>
        matrix(ncol = strtoi(strings[1]), byrow = TRUE) |>
        as.data.frame(stringsAsFactors = FALSE)
    if (col_names || row_names){
    res <- .change_df_with_col_row_header(res, col_names, row_names)
    }
    res <-data.frame(res, check.names = check_names)

    if (inherits(col_types, 'col_spec')){
        res <- readr::type_convert(df = res, col_types = col_types, na = na)
    } else if (length(col_types) == 0 && is.null(col_types)){
        res <- .silent_type_convert(x = res, verbose = verbose, na = na)
    } else if (length(col_types) == 1 && is.na(col_types[1])) {
        {} #Pass
    } else {
        stop("Unknown col_types. Can either be a class col_spec, NULL or NA.", call. = FALSE)
    }

    if (strings_as_factors) {
        res <- .convert_strings_to_factors(res)
    }

    return(res)
}