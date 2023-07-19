test_that("Read fods", {
  expect_silent(a <- read_fods("../testdata/flat.fods"))
  expect_equal(a[1,1], "A2")
  b <- read_fods("../testdata/flat.fods", range = "Sheet2!B2:C3")
  expect_equal(b[1,2], "S2C3")
})
