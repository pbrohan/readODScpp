#include "cpp11.hpp"
#include "cpp11/r_string.hpp"
#include "cpp11/strings.hpp"

#include "rapidxml/rapidxml.hpp"
#include "is_ods.h"

#include <string>
#include <vector>

std::string handle_cell(rapidxml::xml_node<>* node){
    /*https://stackoverflow.com/questions/72013403/rapidxml-c-accessing-text-within-node-but-outside-child-node*/
    std::string out;
    int i = 0;
    for (rapidxml::xml_node<>* n = node->first_node(); n; n=n->next_sibling()){
        if (n->type() == rapidxml::node_element)
        {
            out = out.append(n->value());
        }
        else if (n->type() == rapidxml::node_data){
            out = out.append(n->value());
        }
        i++;
    }
    return out;
}

[[cpp11::register]]
cpp11::r_string get_cell_range(const std::string file, const int sheet){
    if(!is_ods(file)){
        throw std::invalid_argument(file + "is not a correct ODS file");
    } 
    if(sheet < 1){
        throw std::invalid_argument("Cannot have sheet index less than 1");
    }

    cpp11::r_string cell_contents;

    std::string xmlFile = zip_buffer(file, "content.xml");

    rapidxml::xml_document<> spreadsheet;
    spreadsheet.parse<0>(&xmlFile[0]);
    rapidxml::xml_node<>* rootNode;

    rootNode = spreadsheet.first_node()->first_node("office:body")->
        first_node("office:spreadsheet")->first_node("table:table");

    /*navigate to correct sheet*/
    for (int i = 1; i < sheet; i++){
        rootNode = rootNode->next_sibling("table:table");
    }
    /*check if sheet exists. Probably worth doing this earlier. Maybe compare it to the length
    of get_sheets_names*/
    if(!(rootNode)){
        throw std::invalid_argument("Sheet index out of range");
    }

    /*data is only stored in the rows of the sheet*/
    //int row_repeat_count = 1;
    //int col_repeat_count = 1;
    rapidxml::xml_node<>* rowNode = rootNode->first_node("table:table-row");
    rapidxml::xml_node<>* cell;
    cell = rowNode->first_node("table:table-cell");
    //Readxl uses this to convert cell contents to strings. WHY?
    //cell_contents = (cell != NULL) ? Rf_mkCharCE(cell->first_node("text:p")->value(), CE_UTF8) : NA_STRING;
    std::string cell_contents_;
    cell_contents = handle_cell(cell->first_node("text:p"));
    return cell_contents;

}


