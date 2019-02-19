#' @importFrom attempt stop_if_not
#' @importFrom curl has_internet
check_internet <- function(){
  stop_if_not(.x = has_internet(), msg = "Please check your internet connexion")
}

#' @importFrom httr status_code
check_status <- function(res){
  stop_if_not(.x = status_code(res),
              .p = ~ .x == 200,
              msg = "The API returned an error")
}


base_url <- "http://wheelmap.org/api/nodes"



#' Parses content returned by query to the News API.
#'
#' \code{parse_wheelmap_content} parses the content sent back by
#' the News API to an R list.
#'
#' @param response httr response object
#'
#' @importFrom httr content
#' @importFrom utils data
#' @importFrom jsonlite fromJSON
#'
#' @return R list.
parse_wheelmap_content <- function(response){
  content_text    <- httr::content(response, "text")
  content_parsed  <- jsonlite::fromJSON(content_text)
  return(content_parsed)
}

#' Extracts metadata.
#'
#' \code{extract_wheelmap_metadata} extracts meta data from the response object and the
#' parsed content.
#'
#' @param response httr response object
#' @param content_parsed parsed content of a response to News API query
#'
#' @return data frame containing meta data related to the query.
extract_newsanchor_metadata <- function(response, content_parsed){
  metadata <- data.frame(total_results = content_parsed$meta$item_count_total,
                         results_returned = content_parsed$meta$item_count,
                         status_code   = response$status_code,
                         request_date  = response$headers$date,
                         request_url   = response$url,
                         stringsAsFactors = FALSE)
  return(metadata)
}


#' Extracts data frame with News API sources from response object.
#'
#' \code{extract_newsanchor_sources} extracts a data frame containing the News API sources that
#' matched the request to News API sources endpoint.
#'
#' @param metadata data frame containing meta data related to the request, see extract_newsanchor_metadata.
#' @param content_parsed parsed content of a response to News API query
#'
#' @return data frame containing sources.

extract_wheelmap_locations <- function(metadata, content_parsed){
  empty_df <- data.frame()
  if (metadata$status_code == 200) {
    if(metadata$total_results > 0){
      df <- do.call(data.frame, content_parsed$nodes)
      return(df)
    } else {
      warning(paste0("The search was not successful. There were no results",
                     " for your specifications."))
      return(empty_df)
    }
  } else {
    # an error occurred
    warning(paste0("The search resulted in the following error message: ",status_code))
    return(empty_df)
  }
}