library(stringr)
library(terra)



#To start in supervisorctl on esoil use this - "sudo supervisorctl -c /etc/supervisor/supervisord.conf start plumber_SoilFed"

machineName <- as.character(Sys.info()['nodename'])
if(machineName=='soils-discovery'){

  deployDir <-'/srv/plumber/TERNLandscapes/RasterProductsAPI'
  logDir <- '/mnt/data/APILogs/SLGAapi/'
}else{
  deployDir <<-'C:/Users/sea084/OneDrive - CSIRO/RossRCode/Git/TernLandscapes/APIs/RasterProductsAPI'
  logDir <- 'c:/temp/Logs'
}

source(paste0(deployDir, '/config.R'))



#* @apiTitle TERN Landscapes Raster Products API
#* @apiDescription Allows you to drill pixels of TERN Landscapes Raster Products and return values for a cell



#' #' Log system time, request method and HTTP user agent of the incoming request
#' #' @filter logger
#' function(req, res){
#'
#'   logentry <- paste0(as.character(now()), ",",
#'        machineName, ",",
#'        req$REQUEST_METHOD, req$PATH_INFO, ",",
#'        str_replace_all( req$HTTP_USER_AGENT, ",", ""), ",",
#'        req$QUERY_STRING, ",",
#'        req$REMOTE_ADDR
#'       )
#'
#'   dt <- format(Sys.time(), "%d-%m-%Y")
#'
#'   if(!dir.exists(logDir)){
#'      dir.create(logDir , recursive = T)
#'     }
#'
#'   logfile <- paste0(logDir, "/SoilFederationAPI_logs_", dt, ".csv")
#'   try(writeLogEntry(logfile, logentry), silent = TRUE)
#'   plumber::forward()
#' }
#'
#'
#' writeLogEntry <- function(logfile, logentry){
#'
#'   if(file.exists(logfile)){
#'     cat(logentry, '\n', file=logfile, append=T)
#'   }else{
#'     hdr <- paste0('System_time,Server,Request_method,HTTP_user_agent,QUERY_STRING,REMOTE_ADDR\n')
#'     cat(hdr, file=logfile, append=F)
#'     cat(logentry, '\n', file=logfile, append=T)
#'   }
#' }


#* Register to use the API - Your API user name will be your email address and the the API key will be emailed to you
#* @param format (Optional) Format of the response to return. Either json, csv, or xml. Default = json

#* @param organisation (Required) Your organisation name
#* @param email (Required) Your email address
#* @param lastname  (Required) Your surname
#* @param firstname (Required) Your first name
#*
#* @tag Raster Products
#* @get /Register
apiRegister <- function( req, res, firstname=NULL, lastname=NULL,	email=NULL,	organisation=NULL, usr=NULL, key=NULL, format='json'){
  tryCatch({

    rdf <- registerDB( FirstName=firstname, LastName=lastname,	Email=email,	Organisation=organisation)
    resp <- cerealize(rdf, label, format, res)
    return(resp)

  }, error = function(res)
  {
    print(geterrmessage())
    res$status <- 400
    list(error=jsonlite::unbox(geterrmessage()))
  })
}




#* Returns information about the DataSets available the Raster Products Store

#* @param key (Required)  API key for accessing the API.
#* @param usr (Required) User name for accessing the API. To register use the endpoint above "/Register"
#* @param format (Optional) Format of the response to return. Either json, csv, or xml. Default = json

#* @param name (Optional) Filter by Product Name
#* @param component (Optional) Filter by Component name
#* @param attribute (Optional) Filter by Attribute name
#* @param source (Optional) Filter by the Source of the data
#* @param datatype (Optional) Filter by DataType
#* @param product (Optional) Filter by Product name
#*
#* @tag Raster Products
#* @get /ProductInfo
apiGetProducts <- function( req, res, product=NULL, datatype=NULL, source=NULL,	attribute=NULL,	component=NULL, name=NULL, usr=NULL, key=NULL, format='json'){

  tryCatch({

    prodDF <- getMetaData(Product=product, DataType=datatype, Source=source,	Attribute=attribute, Component=component)
    print(prodDF)

   label <- ''

    resp <- cerealize(prodDF, label, format, res)
    return(resp)

  }, error = function(res)
  {
    print(geterrmessage())
    res$status <- 400
    list(error=jsonlite::unbox(geterrmessage()))
  })
}




#* Returns data values at from a raster cell from the Raster Products Store. Any combination of Filters can be used. Some level of filtering must be specified.

#* @param key (Required)  API key for accessing the API.
#* @param usr (Required)  User name for accessing the API. To register for an API key use the endpoint above "Register"
#* @param format (Optional) Format of the response to return. Either json, csv, or xml. Default = json

#* @param verbose  Return Just the raster values and minimal identification (F - default) or return the full product information record with the raster Values

#* @param name (Optional) Filter by Product Name
#* @param component (Optional) Filter by Component name
#* @param attribute (Optional) Filter by Attribute name
#* @param source (Optional) Filter by the Source of the data
#* @param datatype (Optional) Filter by DataType
#* @param product (Optional) Filter by Product name
#* @param latitude (Required) Latitude of the location to extract data for
#* @param longitude (Required) Longitude of the location to extract data for
#*
#* @tag Raster Products
#* @get /Drill
apiDrillRasters <- function( req, res, longitude=NULL, latitude=NULL, product=NULL, datatype=NULL, source=NULL,	attribute=NULL,	component=NULL, name=NULL, usr=NULL, key=NULL, format='json', verbose=T){

  tryCatch({

    #longitude=140; latitude=-28; product=NULL; datatype=NULL; source=NULL;	attribute=NULL;	component=NULL; name='Near-Surface Wind Speed v10 - Annual'; usr='demo.user@somewhere.au'; key='fjhf567sgq'; format='json'; verbose=F

    prodDF <- getDrillData(Longitude=as.numeric(longitude), Latitude=as.numeric(latitude), Product=product, DataType=datatype, Source=source,	Attribute=attribute, Component=component, Name=name, Verbose=verbose, Usr=usr, Key=key)
    print(prodDF)

    label <- ''

    writeLog(df = prodDF, usr = usr, logDir = logDir)
    resp <- cerealize(prodDF, label, format, res)
    return(resp)

  }, error = function(res)
  {
    print(geterrmessage())
    res$status <- 400
    list(error=jsonlite::unbox(geterrmessage()))
  })
}


writeLog <- function(df, usr, logDir){

  if(!dir.exists(logDir)){dir.create(logDir)}
  logFile <- paste0(logDir,'/RasterProductsAPI.csv')
  if(!file.exists(logFile)){
    cat('DateTime,User,Product,Count\n', sep = '', file = logFile, append = F)
  }

  if(nrow(df) > 0){
    sdf <- df %>% group_by(Product) %>% summarise(n = n())
    odf <- data.frame(DateTime=now(),User=usr,Product=sdf$Product,Count=sdf$n, stringsAsFactors = F)
    write.table(odf, logFile,append = TRUE,sep = ",",col.names = FALSE, row.names = FALSE,  quote = FALSE)
  }
}

