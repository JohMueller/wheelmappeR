context("Get locations")
EXPECTED_METADATA_COLUMNS <- sort(c("total_results", "status_code", "request_date", "request_url",
                                    "page_size", "page", "code", "message"))


# TEST INVALID INPUTS
testthat::test_that("test that function returns error if no argument provided", {
  testthat::expect_error(wheelmappeR::get_wheelmap_locations(),
                         regexp = "You need to specify at least one argument")
})

testthat::test_that("test that function returns error if no API key is provided", {
  testthat::expect_error(wheelmappeR::get_wheelmap_locations(q="abc"),
                         regexp = "Please provide your API key as an argument.")
})

testthat::test_that("test that function returns error if search term is not a string", {
  testthat::expect_error(wheelmappeR::get_wheelmap_locations(api_key="123",
                                                             q=1),
                         regexp = "Input for q must be a string.")
})

testthat::test_that("test that function returns error if bbox is not in string format", {
  testthat::expect_error(wheelmappeR::get_wheelmap_locations(api_key="123",
                                                             bbox=1),
                         regexp = "Input for bbox must be a string with four comma-seperated coordinate values; e.g. \"52.357, 52.677, 13.228, 13.548\"")
})

testthat::test_that("test that function returns error if bbox does not contain four coordinates", {
  testthat::expect_error(wheelmappeR::get_wheelmap_locations(api_key="123",
                                                             bbox="12.32, 23.32"),
                         regexp = "Input for bbox must be a string with four comma-seperated coordinate values; e.g. \"52.357, 52.677, 13.228, 13.548\"")
})

testthat::test_that("test that function returns error if wheelchair is not a string", {
  testthat::expect_error(wheelmappeR::get_wheelmap_locations(api_key="123",
                                                             wheelchair=1),
                         regexp = "Input for wheelchair must be one of the following strings \"yes\", \"limited\", \"no\", \"unknown\".")
})

testthat::test_that("test that function returns error if wheelchair is not one of the options", {
  testthat::expect_error(wheelmappeR::get_wheelmap_locations(api_key="123",
                                                             wheelchair="abc"),
                         regexp = "Input for wheelchair must be one of the following strings \"yes\", \"limited\", \"no\", \"unknown\".")
})

testthat::test_that("test that function returns error if page argument is not numeric", {
  testthat::expect_error(wheelmappeR::get_wheelmap_locations(api_key="123",
                                                             page="abc"),
                         regexp = "Input for page must be a numeric.")
})

testthat::test_that("test that function returns error if per_page argument is not numeric", {
  testthat::expect_error(wheelmappeR::get_wheelmap_locations(api_key="123",
                                                             per_page="abc"),
                         regexp = "Input for per_page must be a numeric.")
})





