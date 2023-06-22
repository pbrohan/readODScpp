#include "cpp11.hpp"
#include "cpp11/r_string.hpp"
#include "cpp11/strings.hpp"

#include "rapidxml/rapidxml.hpp"
#include "is_ods.hpp"

#include <string>
#include <vector>

[[cpp11::register]]
cpp11::strings get_cell_range(const std::string file,
                                const int sheet_num,
                                const int start_row,
                                const int stop_row,
                                const int start_col,
                                const int stop_col){
    if (!is_ods(file)){
        throw std::invalid_argument(file + "is not a correct ODS file");
    }
    cpp11::writable::strings cell_contents((stop_row-start_row)*(stop_col-start_col));
    
    std::string xmlFile = zip_buffer(file, "content.xml");

    rapidxml::xml_document<> spreadsheet;
    spreadsheet.parse<0>(&xmlFile[0]);
    rapidxml::xml_node<>* rootNode;

    rootNode = spreadsheet.first_node()->first_node("office:body")->
        first_node("office:spreadsheet")->first_node("table:table");

    /*navigate to correct sheet*/
    for (int i = 1; i < sheet_num; i++){
        rootNode = rootNode->next_sibling("table:table");
    }
    /*check if sheet exists. Probably worth doing this earlier and comparing it to the 
    length of get_sheets_names*/
    if(!(rootNode)){
        throw std::invalid_argument("Sheet index out of range");
    }
    
    int temp = 0;


    /*data is stored in the rows*/
    int row_repeat_count = 1; // Use 1-indexing because R
    int col_repeat_count = 1;
    rapidxml::xml_node<>* rowNode = rootNode->first_node("table:table-row");
    rapidxml::xml_node<>* cell;
    //This is not good. Refactor somehow :()
    for (int i = 1; i <= stop_row; i++){
        if (i >= start_row){
            cell = rowNode->first_node("table:table-cell");
            for (int j = 1; j <= stop_col; j++){
                if (j >= start_col){
                    cell_contents[temp] = (cell != NULL) ? Rf_mkCharCE(cell->first_node("text:p")->value(), CE_UTF8) : NA_STRING;
                    temp++;
                    /*If cell is repeated*/
                    if(rowNode->first_attribute("table:number-columns-repeated")){
                        int col_reps = std::atoi(rowNode->first_attribute("table:number-columns-repeated")->value());
                        while(col_repeat_count < col_reps && j <= stop_col){
                            cell_contents[temp] = (cell != NULL) ? Rf_mkCharCE(cell->first_node("text:p")->value(), CE_UTF8) : NA_STRING;
                            temp++;
                            col_repeat_count++;
                            j++;
                        }
                        col_repeat_count = 1;
                    }
                }
                cell = cell->next_sibling("table:table-cell");
            }
        }

    }
    
    return cell_contents;
    }