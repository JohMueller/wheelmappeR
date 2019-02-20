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

#' Parses content returned by query to the Wheelmap API.
#'
#' \code{parse_wheelmap_content} parses the content sent back by
#' the Wheelmap API to an R list.
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
#' @param content_parsed parsed content of a response to Wheelmap query
#'
#' @return data frame containing meta data related to the query.
extract_wheelmap_metadata <- function(response, content_parsed){
  metadata <- data.frame(total_results = content_parsed$meta$item_count_total,
                         results_returned = content_parsed$meta$item_count,
                         status_code   = response$status_code,
                         request_date  = response$headers$date,
                         request_url   = response$url,
                         stringsAsFactors = FALSE)
  return(metadata)
}


#' Extracts data frame with Wheelmap locations from response object.
#'
#' \code{extract_wheelmap_locations} extracts a data frame containing the Wheelmap sources that
#' matched the request to Wheelmap location endpoint.
#'
#' @param metadata data frame containing meta data related to the request, see extract_wheelmap_metadata.
#' @param content_parsed parsed content of a response to wheelmap query
#'
#' @return data frame containing sources.

extract_wheelmap_locations <- function(metadata, content_parsed){
  empty_df <- data.frame()
  if (metadata$status_code == 200) {
    if(metadata$total_results > 0){
      # from list to data.frame
      df <- do.call(data.frame, content_parsed$nodes)
      #clean df
      df$name <- as.character(df$name)
      df$wheelchair_description <- as.character(df$wheelchair_description)
      df$node_type.identifier <- as.factor(df$node_type.identifier)
      df$id <- as.character(df$id)
      df$category.identifier <- as.factor(df$category.identifier)
      df$street <- as.character(df$street)
      df$housenumber <- as.character(df$housenumber)
      df$city <- as.character(df$city)
      df$postcode <- as.character(df$postcode)
      df$website <- as.character(df$website)
      df$phone <- as.character(df$phone)

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

