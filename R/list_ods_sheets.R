#' List all sheets in an ODS File
#' 
#' List all sheets in an ods file.
#' 
#' @param path Path to the ods file
#' @param include_external_data A boolean value to show or hide sheets containing linked data (default false)
#' @return A character vector of sheet names.
#' @export
list_ods_sheets <- function(path, include_external_data = FALSE) {
    return(ods_get_sheet_names(path, include_external_data))
}