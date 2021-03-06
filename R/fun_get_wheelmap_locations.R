#' Get list of all locations
#'
#' @param api_key Your API key
#' @param q Filter nodes by a search term
#' @param bbox Filter nodes by a bounding box (bbox=west,south,east,north) as comma separated float numbers wich are longitude, latitude values in degrees.
#' @param wheelchair Filter nodes by a wheelchair status (Valid values: yes, limited, no, unknown)
#' @param page For pagination, what page of the results you are on. Default is 1.
#' @param per_page For pagination, how many results to return per page. Default is 200. Max is 500.
#'
#' @importFrom attempt stop_if_all
#' @importFrom purrr compact
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @export
#' @rdname get_wheelmap_locations
#'
#' @return the results from the search
#' @examples
#' \dontrun{
#' get_wheelmap_locations(api_key = api_key, bbox="52.35, 52.67, 13.22, 13.54")
#'
#' # Example bbox values for different cities
#' # Berlin "52.3570365, 52.6770365, 13.2288599, 13.5488599"
#' # Dortmund "51.3542273, 51.6742273, 7.3052789, 7.6252789"
#' # Frankfurt "50.0155435, 50.2271408, 8.4718253, 8.8004716"
#' # Hamburg "53.3951118, 53.7394377, 9.7304736, 10.3251401"
#' # Munich "48.0616017, 48.2482197, 11.3607802, 11.7228777"
#' }

get_wheelmap_locations <- function(api_key=NULL,q = NULL, bbox = NULL, wheelchair = NULL, page = NULL, per_page = NULL){

  args <- list(api_key = api_key, q = q, bbox=bbox, wheelchair=wheelchair, page = page,per_page=per_page)

  # Check that at least one argument is not null
  stop_if_all(args[2:6], is.null, "You need to specify at least one argument")

  #check if data type of input arguments is correct
  if (is.null(api_key)) {
    stop("Please provide your API key as an argument.")
  }
  if (!is.null(q) & !is.character(q)) {
    stop("Input for q must be a string.")
  }
  if (!is.null(bbox) & !is.character(bbox)){
    stop("Input for bbox must be a string with four comma-seperated coordinate values; e.g. \"52.357, 52.677, 13.228, 13.548\"")
  }
  if (!is.null(bbox) & !is.character(bbox)){
    stop("Input for bbox must be a string with four comma-seperated coordinate values; e.g. \"52.357, 52.677, 13.228, 13.548\"")
  }

  if(!is.null(bbox)){
    if(is.character(bbox) & length(strsplit(bbox, ",")[[1]]) != 4){
      stop("Input for bbox must be a string with four comma-seperated coordinate values; e.g. \"52.357, 52.677, 13.228, 13.548\"")
    }
  }

  if(!is.null(wheelchair)&!is.character(wheelchair)){
    stop("Input for wheelchair must be one of the following strings \"yes\", \"limited\", \"no\", \"unknown\".")
  }

  if(!is.null(wheelchair)){
    if(is.character(wheelchair)&!(wheelchair %in% c("yes", "limited", "no", "unknown"))){
      stop("Input for wheelchair must be one of the following strings \"yes\", \"limited\", \"no\", \"unknown\".")
    }
  }
  if (!is.null(page) & !is.numeric(page)) {
    stop("Input for page must be a numeric.")
  }
  if (!is.null(per_page) & !is.numeric(per_page)) {
    stop("Input for per_page must be a numeric.")
  }

  # Chek for internet
  check_internet()
  # Retrieve the results
  res <- GET(base_url, query = compact(args))
  # Check the result
  check_status(res)
  # Get the content and return it as a data.frame
  content_parsed <- parse_wheelmap_content(res)
  # Get meta data
  meta <- extract_wheelmap_metadata(res, content_parsed)
  # extract results
  locations <- extract_wheelmap_locations(meta, content_parsed)

  # format output
  output <- list(meta,locations)
  names(output) <- c("meta_data", "locations")
  # return results in list
  return(output)
}

