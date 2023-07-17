    
    #1
    
    ods_3r <- read_ods('../testdata/cellranger_issue57.ods', sheet = 1, range = "A1:B4", col_names = TRUE)
    ods_2r <- read_ods('../testdata/cellranger_issue57.ods', sheet = 1, range = "A1:B3", col_names = TRUE)
    ods_a2_1r <- read_ods('../testdata/cellranger_issue57.ods', sheet = 1, range = "A2:B3", col_names = TRUE)
    ods_a1_noheader_3r <- read_ods('../testdata/cellranger_issue57.ods', sheet = 1, range = "A1:B3", col_names = FALSE)
    expect_equal(nrow(ods_3r), 3)
    expect_equal(nrow(ods_2r), 2)
    expect_equal(nrow(ods_2r), 2)
    expect_equal(nrow(ods_a2_1r), 1)
    expect_equal(nrow(ods_a1_noheader_3r), 3)
    expect_equal(ods_3r[3,1], 3)
    expect_equal(ods_2r[2,1], 2)
    expect_equal(colnames(ods_a2_1r)[1], "1")

    #2.1
    x <- read_ods('../testdata/col_types.ods', col_types = NA)
    expect_equal(class(x[,2]), "character")
    x <- read_ods('../testdata/col_types.ods')
    expect_equal(class(x[,2]), "numeric")

    #2.2
    x <- read_ods('../testdata/col_types.ods', col_types = NA)
    expect_equal(class(x[,2]), "character")
    x <- read_ods('../testdata/col_types.ods', col_types = readr::cols(cola = 'c', colb = 'c', colc = 'i'))
    expect_equal(class(x[,2]), "character")

    #2.3
    expect_error(read_ods('../testdata/col_types.ods', col_types = 123))
    expect_error(read_ods('../testdata/col_types.ods', col_types = c(NA, NA)))
    expect_error(read_ods('../testdata/col_types.ods', col_types = c(NA, 123)))

    #3.1
    res <- read_ods("../testdata/excel_repeat.ods", col_names = FALSE)
    expect_identical(res[,1], c(rep("A", 12), rep("C", 11)))
    expect_identical(res[,2], c(rep("B", 12), rep("D", 11)))

    #3.2
    file <- "../testdata/issue81.ods"
    res <- read_ods(file, sheet = 2, skip = 4)
    expect_equal(sum(is.na(res[,1])), 0)

    #3.3
    file <- "../testdata/issue81.ods"
    expect_error(read_ods(file, sheet = "Leavers"), NA)

    #4.1
    file <- "../testdata/test.ods"
    expect_equal(get_num_sheets_in_ods(file),1)
    file <- "../testdata/multisheet.ods"
    expect_equal(get_num_sheets_in_ods(file),4)
    file <- "../testdata/sum.ods"
    expect_equal(get_num_sheets_in_ods(file),1)
    file <- "../testdata/readODStestfilegoogledocscreated.ods"
    expect_equal(get_num_sheets_in_ods(file),4)

    #4.2
    file <- "../testdata/sum.ods"
    expect_equal(read_ods(file, sheet=1, col_names = FALSE, formula_as_formula=TRUE)[3,1],"of:=SUM([.A1:.A2])")
    expect_equal(read_ods(file, sheet=1, col_names = FALSE, col_types = NA, formula_as_formula=FALSE)[3,1],"3")
  
    df <- data.frame(A = as.character(1:3),stringsAsFactors = F)
    rODS <- read_ods(file, sheet = 1, col_names = FALSE, col_types=NA, formula_as_formula = FALSE)
    expect_equal(rODS, df)
  
    file <- "../testdata/lotsofnothing_test.ods"
    expect_equal(dim(read_ods(file, sheet = 1, col_names = FALSE)),c(21,13)) # test if empty rows at the end are ignored
    expect_equal(class(read_ods(file, sheet=1)), "data.frame")
    ## small file
    file <- "../testdata/table.ods"
    df <- data.frame(V1 = c("gender", "m", "f", "m"),
        V2 = c("visit1", "4", "8", "8"),
        V3 = c("visit2", "6", "9", "2"),
        V4 = c("visit3", "8", "4", "1"),
        stringsAsFactors = F)
    expect_equal(read_ods(file, sheet = 1, col_names = FALSE, col_types = NA), df)
    
    file <- "../testdata/layout_test.ods"
    sheet1 <- read_ods(file, sheet = 1, col_names = FALSE)
    expect_equal(sheet1[8, "F"], "empty") # this is a repeated element
    
    sheet2 <- read_ods(file, sheet=2, col_names = FALSE)
    expect_equal(dim(sheet2),c(22,13))
    expect_true(all(sheet1[21,]==sheet2[22,]))
    
    file <- paste("../testdata/multisheet.ods",sep="")
    df <- data.frame(matrix(as.character(NA),14,7),stringsAsFactors = F)
    df[1,1] <- "COOKIES"
    df[4,2] <- "1"
    df[6,3] <- "2"
    df[8,3] <- "3"
    df[14,4] <- "3"
    df[7,5] <- "3"
    df[9,5] <- "1"
    df[10,7] <- "1"
    sheet2 <- read_ods(file, sheet=2, col_names = FALSE)
    expect_true(all(sheet2==df, na.rm = TRUE))
 
    file <- "../testdata/1996-2000.ods"
    expect_true(all(dim(read_ods(file, sheet = 2, col_names = FALSE)) == c(36, 21)))

    #5
    x <- read_ods('../testdata/multiline_cells.ods', col_names = FALSE)
    expect_equal(x[1,1], "Multiline cell, line 1\nMultiline cell, line 2")

    #6.1
    na_res <- read_ods('../testdata/na_test.ods', na = c("3", "999", "missing"))
    expect_true(is.na(na_res[4,1]))
    expect_true(is.na(na_res[4,2]))
    expect_true(is.na(na_res[3,3]))
    expect_true(is.na(na_res[4,3]))

    #6.2
    na_res <- read_ods('../testdata/na_test2.ods', na = c("one"))
    expect_true(is.na(na_res[1,1]))
    expect_false(is.na(na_res[2,1]))
    expect_false(is.na(na_res[3,1]))
    expect_false(is.na(na_res[4,1]))
    expect_false(is.na(na_res[5,1]))
    expect_false(is.na(na_res[6,1]))
    expect_false(is.na(na_res[7,1]))
    expect_false(is.na(na_res[8,1]))
    expect_false(is.na(na_res[9,1]))
    expect_false(is.na(na_res[10,1]))
    expect_equal((na_res[2,1]), "NaN")
    expect_equal((na_res[4,1]), "")
    expect_equal((na_res[6,1]), "NA")
    expect_equal((na_res[7,1]), "NA")
    expect_equal((na_res[8,1]), "")

    #6.3
    na_res <- read_ods('../testdata/na_test3.ods', na = c("one"))
    expect_true(is.na(na_res[1,1]))
    expect_false(is.na(na_res[2,1]))
    expect_false(any(is.na(na_res$ex1[2:9])))
    expect_false(any(is.na(na_res$ex2[1:9])))
    expect_true(any(is.na(na_res$ex3[1:9]))) ## due to col_types
    expect_false(any(is.na(na_res$ex4[1:9])))
    na_res <- read_ods('../testdata/na_test3.ods', na = c("one"), col_types = readr::cols(ex1 = "c", ex2 = "c", ex3 = "c", ex4 = "c"))
    expect_true(is.na(na_res[1,1]))
    expect_false(is.na(na_res[2,1]))
    expect_false(any(is.na(na_res$ex1[2:9])))
    expect_false(any(is.na(na_res$ex2[1:9])))
    expect_false(any(is.na(na_res$ex3[1:9])))
    expect_false(any(is.na(na_res$ex4[1:9])))

    #7.1
    expect_error(read_ods(), "No file path was")
    expect_error(read_ods(path = "a", col_names = "a"), "col_names must be of type `boolean`")
    expect_error(read_ods(path = '../testdata/sum.ods', col_types = "a"), "Unknown col_types. Can either be a class col_spec, NULL or NA.")
    expect_error(read_ods(path = "a", skip = -1), "skip must be a positive integer")
    expect_error(read_ods(path = "a", formula_as_formula = "a"), "formula_as_formula must be of type `boolean`")
    expect_error(read_ods(path = "a", row_names = "a"), "row_names must be of type `boolean`")
    expect_error(read_ods(path = "a", strings_as_factors = "a"), "strings_as_factors must be of type `boolean`")
    expect_error(read_ods(path = "a", check_names = "a"), "check_names must be of type `boolean`")
    expect_error(read_ods(path = "a", verbose = "a"), "verbose must be of type `boolean`")

    #7.2
    single_col <- read_ods('../testdata/sum.ods', sheet = 1)
    expect_equal(ncol(single_col),1)
    expect_equal(colnames(single_col), c("1"))
    expect_warning(read_ods('../testdata/sum.ods', sheet = 1, row_names = TRUE), "Cannot make")

    #NEW! Single Row
    expect_warning(single_row <- read_ods('../testdata/onerow.ods', sheet = 1), "Cannot make")
    expect_equal(nrow(single_row), 1)
    expect_equal(single_row[1,1], 1)

    #NEW Range is single column
    expect_error(read_ods("../testdata/starwars.ods", range="A1:A5"), NA)

    #7.3
    expect_error(read_ods('../testdata/wild_character_encoding.ods', sheet='évaluation'),  NA) # é as e and accent
    expect_error(read_ods('../testdata/wild_character_encoding.ods', sheet='évaluation 2'), NA) # é as one character


    #7.4
    df <- read_ods('../testdata/decimal_comma.ods')
    df_expected <- structure(list(A = 3.4, B = 2.3, C = 0.03),
                           .Names = c("A", "B", "C"),
                           row.names = 1L, class = "data.frame")
    expect_equal(df, df_expected)

    #7.5
    df <- read_ods("../testdata/eating_spaces.ods", sheet = 2, col_names = FALSE)
    expect_equal(df[1,1], "A   B")
    df <- read_ods("../testdata/eating_spaces.ods", sheet = 3, col_names = FALSE)
    expect_equal(df[1,1], "A    B C")
    df <- read_ods("../testdata/eating_spaces.ods", sheet = 4, col_names = FALSE)
    expect_equal(df[1,1], "A     B   C")
    df <- read_ods("../testdata/eating_spaces.ods", sheet = 5, col_names = FALSE)
    expect_equal(df[1,1], "A     B\nC")

    #7.6
    expect_silent(x <- read_ods("../testdata/starwars.ods", skip = 0))
    expect_equal(nrow(x), 10)
    expect_silent(x <- read_ods("../testdata/starwars.ods", skip = 1, col_names = FALSE))
    expect_equal(nrow(x), 10)
    expect_warning(x <- read_ods("../testdata/starwars.ods", skip = 11))
    expect_equal(nrow(x), 0)

    #7.7
    expect_silent(x <- read_ods("../testdata/test_naming.ods"))
    expect_equal(colnames(x), c("a", "a", "Var.3"))
    expect_silent(x <- read_ods("../testdata/test_naming.ods", check_names = TRUE))
    expect_equal(colnames(x), c("a", "a.1", "Var.3"))

    #8.1
    expect_silent(read_ods('../testdata/col_types.ods'))
    expect_message(read_ods('../testdata/col_types.ods', verbose = TRUE))
   # ..