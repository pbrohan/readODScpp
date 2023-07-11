#include "cpp11.hpp"
#include "cpp11/r_string.hpp"
#include "cpp11/strings.hpp"

#include "rapidxml/rapidxml.hpp"
#include "is_ods.h"

#include <string>
#include <vector>

[[cpp11::register]]
cpp11::r_string get_a1(const std::string file, const int sheet){
    if(!is_ods(file)){
        throw std::invalid_argument(file + "is not a correct ODS file");
    } 

    

    return "Hello";

}