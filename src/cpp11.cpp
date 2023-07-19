// Generated by cpp11: do not edit by hand
// clang-format off


#include "cpp11/declarations.hpp"
#include <R_ext/Visibility.h>

// get_sheet_names.cpp
cpp11::strings get_sheet_names_(const std::string file, const bool include_external_data);
extern "C" SEXP _readODScpp_get_sheet_names_(SEXP file, SEXP include_external_data) {
  BEGIN_CPP11
    return cpp11::as_sexp(get_sheet_names_(cpp11::as_cpp<cpp11::decay_t<const std::string>>(file), cpp11::as_cpp<cpp11::decay_t<const bool>>(include_external_data)));
  END_CPP11
}
// get_sheet_names.cpp
cpp11::strings get_flat_sheet_names_(const std::string file, const bool include_external_data);
extern "C" SEXP _readODScpp_get_flat_sheet_names_(SEXP file, SEXP include_external_data) {
  BEGIN_CPP11
    return cpp11::as_sexp(get_flat_sheet_names_(cpp11::as_cpp<cpp11::decay_t<const std::string>>(file), cpp11::as_cpp<cpp11::decay_t<const bool>>(include_external_data)));
  END_CPP11
}
// read_flat_ods_.cpp
cpp11::strings read_flat_ods_(const std::string file, int start_row, int stop_row, int start_col, int stop_col, const int sheet, const bool formula_as_formula);
extern "C" SEXP _readODScpp_read_flat_ods_(SEXP file, SEXP start_row, SEXP stop_row, SEXP start_col, SEXP stop_col, SEXP sheet, SEXP formula_as_formula) {
  BEGIN_CPP11
    return cpp11::as_sexp(read_flat_ods_(cpp11::as_cpp<cpp11::decay_t<const std::string>>(file), cpp11::as_cpp<cpp11::decay_t<int>>(start_row), cpp11::as_cpp<cpp11::decay_t<int>>(stop_row), cpp11::as_cpp<cpp11::decay_t<int>>(start_col), cpp11::as_cpp<cpp11::decay_t<int>>(stop_col), cpp11::as_cpp<cpp11::decay_t<const int>>(sheet), cpp11::as_cpp<cpp11::decay_t<const bool>>(formula_as_formula)));
  END_CPP11
}
// read_ods_.cpp
cpp11::strings read_ods_(const std::string file, int start_row, int stop_row, int start_col, int stop_col, const int sheet, const bool formula_as_formula);
extern "C" SEXP _readODScpp_read_ods_(SEXP file, SEXP start_row, SEXP stop_row, SEXP start_col, SEXP stop_col, SEXP sheet, SEXP formula_as_formula) {
  BEGIN_CPP11
    return cpp11::as_sexp(read_ods_(cpp11::as_cpp<cpp11::decay_t<const std::string>>(file), cpp11::as_cpp<cpp11::decay_t<int>>(start_row), cpp11::as_cpp<cpp11::decay_t<int>>(stop_row), cpp11::as_cpp<cpp11::decay_t<int>>(start_col), cpp11::as_cpp<cpp11::decay_t<int>>(stop_col), cpp11::as_cpp<cpp11::decay_t<const int>>(sheet), cpp11::as_cpp<cpp11::decay_t<const bool>>(formula_as_formula)));
  END_CPP11
}

extern "C" {
static const R_CallMethodDef CallEntries[] = {
    {"_readODScpp_get_flat_sheet_names_", (DL_FUNC) &_readODScpp_get_flat_sheet_names_, 2},
    {"_readODScpp_get_sheet_names_",      (DL_FUNC) &_readODScpp_get_sheet_names_,      2},
    {"_readODScpp_read_flat_ods_",        (DL_FUNC) &_readODScpp_read_flat_ods_,        7},
    {"_readODScpp_read_ods_",             (DL_FUNC) &_readODScpp_read_ods_,             7},
    {NULL, NULL, 0}
};
}

extern "C" attribute_visible void R_init_readODScpp(DllInfo* dll){
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}
