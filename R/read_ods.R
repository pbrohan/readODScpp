#' Read the data from an ODS file
#' 
#' 
#' 
read_ods_cpp <- function(path,
                        sheet = 1,
                        startcol = 1,
                        stopcol = -1,
                        startrow = 1,
                        stoprow = - 1
){

    strings <- read_ods_(path, startrow, stoprow, startcol, stopcol, sheet)
    out = strings[-1:-2] |>
        matrix(ncol = strtoi(strings[1]), byrow = TRUE) |>
        as.data.frame(stringsAsFactors = FALSE)
    return(out)
}