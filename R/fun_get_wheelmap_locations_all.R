#' Get list of all locations
#'
#' @param api_key Your API key
#' @param q Filter nodes by a search term
#' @param bbox Filter nodes by a bounding box (bbox=west,south,east,north) as comma separated float numbers wich are longitude, latitude values in degrees.
#' @param wheelchair Filter nodes by a wheelchair status (Valid values: yes, limited, no, unknown)
#'
#' @importFrom attempt stop_if_all
#' @importFrom purrr compact
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @export
#' @rdname get_wheelmap_locations_all
#'
#' @return the results from the search
#' @examples
#' \dontrun{
#' get_wheelmap_locations_all(api_key = api_key, bbox="52.3570365, 52.6770365, 13.2288599, 13.5488599") #Daten für Berlin
#' }

get_wheelmap_locations_all <- function(api_key=api_key,q = NULL, bbox = NULL, wheelchair = NULL){

  init <- get_wheelmap_locations(api_key = api_key, q = q, bbox=bbox, wheelchair=wheelchair, page = 1,per_page=500) # max
  total_pages <- floor(init[[1]]$total_results/500)+1

  #Initalize Dataframe
  df <- init[[2]]

  #Loop over pages
  for(i in 2:total_pages){
    new <- get_wheelmap_locations(api_key = api_key, q = q, bbox=bbox, wheelchair=wheelchair, page = i,per_page=500)
    df <- rbind(df, new[[2]], make.row.names=T)
    print(paste0("Processing page ", i," of ",total_pages))
  }
  return(list(init[[1]], df))
}
