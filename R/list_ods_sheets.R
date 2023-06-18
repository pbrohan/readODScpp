#' List all sheets in an ODS File
#' 
#' List all sheets in an ods file.
#' 
#' @param path Path to the ods file
#' @return A character vector of sheet names.
#' @export
list_ods_sheets <- function(path) {
    return(ods_get_sheet_names(path))
}